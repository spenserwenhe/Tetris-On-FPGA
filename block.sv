//-------------------------------------------------------------------------
//    CurrBlock.sv
// will probably make an sv file for one of the four pixels                                                                                            --
//-------------------------------------------------------------------------
//restarted from scratch
module randomizer(input clk,
						output [2:0] randomVal);
	//randomizer
	 //logic [2:0] random;
	 logic [2:0] nextRandomVal, seed;
	 int random = 1;
	 
	 
	 assign randomVal = random;
	 
	always_ff @ (posedge clk)
	begin
		if(random == 257)
			random <= 1;
		else
			random <= random + 1;
	end
endmodule

module  CurrBlock ( input Reset, frame_clk, clk,
					//input logic [2:0] random,
					input logic Spawn,
					input [7:0] keycode, 
					input [9:0] difficulty,
					input [9:0]fallenBlocks[19:0],
					output fell, gameOver, startGame, //send gameOver signal to switch states
					output logic lineBreak, //send lineBreak signal to start breaking lines and adding score
               output [9:0]currBlocks [19:0],
					output [2:0] shape,
					output [5:0] Xpos, Ypos);
    
	 
	 assign Xpos = CurrBlock_X_Pos;
	 assign Ypos = CurrBlock_Y_Pos;
	 //current center position of the center block and block motion
    //logic [9:0] /*CurrBlock_X_Pos, CurrBlock_X_Motion,CurrBlock_Y_Pos,CurrBlock_Y_Motion,*/Block_Size;//IRRELEVANT
	 
	 //current position!!! important for grid!!!!
	 int CurrBlock_X_Pos, CurrBlock_X_Motion;
	 int CurrBlock_Y_Pos;
	 int fallInterference, leftInterference, rightInterference, rotInterference; //high if fallen block exists below
	 int CurrBlock_Y_Motion, tempCurrBlock_Y_Pos;
	 //canNOT use floats so we will instead have a temporary count variable to count how many frames
	 //it will take in order to append 1 to the y position
	 int yCount;
	 int CB1X,CB1Y,CB2X,CB2Y,CB3X,CB3Y,CB4X,CB4Y; //CURRENT position for each block
	
	 int CB1X0,CB1Y0,CB2X0,CB2Y0,CB3X0,CB3Y0,CB4X0,CB4Y0; //CURRENT position for default rotation
	 int CB1X1,CB1Y1,CB2X1,CB2Y1,CB3X1,CB3Y1,CB4X1,CB4Y1; //CURRENT position for rotation 1
	 int CB1X2,CB1Y2,CB2X2,CB2Y2,CB3X2,CB3Y2,CB4X2,CB4Y2; //CURRENT position for rotation 2
	 int CB1X3,CB1Y3,CB2X3,CB2Y3,CB3X3,CB3Y3,CB4X3,CB4Y3; //CURRENT position for rotation 3
	
	 //center position is initial position, top center of screen for curr block
	 //use grid method lmao so 19:0 rows and 9:0 columns
	 //int CurrBlock_X_Center = 4; //initial X position
	 //int CurrBlock_Y_Center = 0; //initial Y position
    //parameter [9:0] CurrBlock_X_Center=4;  // Center position on the X axis
    //parameter [9:0] CurrBlock_Y_Center=0;  // Center position on the Y axis  CB1X???
    parameter [9:0] CurrBlock_X_Min=200;//IRRELEVANT       // Leftmost point on the X axis
    parameter [9:0] CurrBlock_X_Max=439;//IRRELEVANT     // Rightmost point on the X axis
    parameter [9:0] CurrBlock_Y_Min=0;//IRRELEVANT       // Topmost point on the Y axis
    parameter [9:0] CurrBlock_Y_Max=479;//IRELEVANT     // Bottommost point on the Y axis
    parameter [9:0] CurrBlock_X_Step=1;//IRRELEVANT      // Step size on the X axis (one coordinates worth)
    parameter [9:0] CurrBlock_Y_Step=1;//IRRELEVANT      // Step size on the Y axis (just 1 so it can slowly fall)
	 //use CurrBlockCenter as a frickin parameter to colorize the background!!!!!
	 
	 logic[2:0] random, randomVal;
	 //intermediate logic for the keys
	 assign shape = random;
	 logic Apressed, Wpressed, Dpressed, spacePressed;
	 logic [1:0] currRotation;
	 
	 randomizer Randomizer(.clk(clk),
									.randomVal(randomVal));
	 
	always_comb
	begin
	//default values
		CB1X = 0; //topleft block
		CB1Y = 0;
		CB2X = 0;//topright block
		CB2Y = 0; 
		CB3X = 0; //botleft
		CB3Y = 0;
		CB4X = 0; //botright
		CB4Y = 0;

	if(currRotation ==1)
	begin
		CB1X = CB1X1; //topleft block
		CB1Y = CB1Y1;
		CB2X = CB2X1;//topright block
		CB2Y = CB2Y1; 
		CB3X = CB3X1; //botleft
		CB3Y = CB3Y1;
		CB4X = CB4X1; //botright
		CB4Y = CB4Y1;
	end
	else if(currRotation ==2)
	begin
		CB1X = CB1X2; //topleft block
		CB1Y = CB1Y2;
		CB2X = CB2X2;//topright block
		CB2Y = CB2Y2; 
		CB3X = CB3X2; //botleft
		CB3Y = CB3Y2;
		CB4X = CB4X2; //botright
		CB4Y = CB4Y2;
	end
	else if(currRotation ==3)
	begin
		CB1X = CB1X3; //topleft block
		CB1Y = CB1Y3;
		CB2X = CB2X3;//topright block
		CB2Y = CB2Y3; 
		CB3X = CB3X3; //botleft
		CB3Y = CB3Y3;
		CB4X = CB4X3; //botright
		CB4Y = CB4Y3;
	end
	else if(currRotation == 0)//rotation == 0
	begin
		CB1X = CB1X0; //topleft block
		CB1Y = CB1Y0;
		CB2X = CB2X0;//topright block
		CB2Y = CB2Y0; 
		CB3X = CB3X0; //botleft
		CB3Y = CB3Y0;
		CB4X = CB4X0; //botright
		CB4Y = CB4Y0;
	end
	//have CB1x be the LEFTMOST block (so we dont need to check all of them)
	//CB4X will be the RIGHTMOST block
	//CB2Y will be the TOPMOST BLOCK
	//CB3Y will be the BOTTOM MOST block
		case(random)
			default: //3'b000: //empty
				begin
					CB1X1 = CurrBlock_X_Pos; //topleft block
					CB1Y1 = CurrBlock_Y_Pos;
					CB2X1 = CurrBlock_X_Pos;//topright block
					CB2Y1 = CurrBlock_Y_Pos-1; 
					CB3X1 = CurrBlock_X_Pos; //botleft
					CB3Y1 = CurrBlock_Y_Pos+2;
					CB4X1 = CurrBlock_X_Pos; //botright
					CB4Y1 = CurrBlock_Y_Pos+1;
					
					CB1X3 = CurrBlock_X_Pos; //topleft block
					CB1Y3 = CurrBlock_Y_Pos;
					CB2X3 = CurrBlock_X_Pos;//topright block
					CB2Y3 = CurrBlock_Y_Pos-1; 
					CB3X3 = CurrBlock_X_Pos; //botleft
					CB3Y3 = CurrBlock_Y_Pos+2;
					CB4X3 = CurrBlock_X_Pos; //botright
					CB4Y3 = CurrBlock_Y_Pos+1;

					CB1X0 = CurrBlock_X_Pos-1; //topleft block
					CB1Y0 = CurrBlock_Y_Pos;
					CB2X0 = CurrBlock_X_Pos;//topright block
					CB2Y0 = CurrBlock_Y_Pos; 
					CB3X0 = CurrBlock_X_Pos+1; //botleft
					CB3Y0 = CurrBlock_Y_Pos;
					CB4X0 = CurrBlock_X_Pos+2; //botright
					CB4Y0 = CurrBlock_Y_Pos;
					
					CB1X2 = CurrBlock_X_Pos-1; //topleft block
					CB1Y2 = CurrBlock_Y_Pos;
					CB2X2 = CurrBlock_X_Pos;//topright block
					CB2Y2 = CurrBlock_Y_Pos; 
					CB3X2 = CurrBlock_X_Pos+1; //botleft
					CB3Y2 = CurrBlock_Y_Pos;
					CB4X2 = CurrBlock_X_Pos+2; //botright
					CB4Y2 = CurrBlock_Y_Pos;
				end
			3'b001: //OBlock done
				begin
				//center coords for each block
					CB1X0 = CurrBlock_X_Pos; //topleft block
					CB1Y0 = CurrBlock_Y_Pos;
					CB2X0 = CurrBlock_X_Pos+1;//topright block
					CB2Y0 = CurrBlock_Y_Pos; 
					CB3X0 = CurrBlock_X_Pos; //botleft
					CB3Y0 = CurrBlock_Y_Pos+1;
					CB4X0 = CurrBlock_X_Pos+1; //botright
					CB4Y0 = CurrBlock_Y_Pos+1;

					CB1X1 = CB1X0; //topleft block
					CB1Y1 = CB1Y0;
					CB2X1 = CB2X0;//topright block
					CB2Y1 = CB2Y0; 
					CB3X1 = CB3X0; //botleft
					CB3Y1 = CB3Y0;
					CB4X1 = CB4X0; //botright
					CB4Y1 = CB4Y0;

					CB1X2 = CB1X0; //topleft block
					CB1Y2 = CB1Y0;
					CB2X2 = CB2X0;//topright block
					CB2Y2 = CB2Y0; 
					CB3X2 = CB3X0; //botleft
					CB3Y2 = CB3Y0;
					CB4X2 = CB4X0; //botright
					CB4Y2 = CB4Y0;

					CB1X3 = CB1X0; //topleft block
					CB1Y3 = CB1Y0;
					CB2X3 = CB2X0;//topright block
					CB2Y3 = CB2Y0; 
					CB3X3 = CB3X0; //botleft
					CB3Y3 = CB3Y0;
					CB4X3 = CB4X0; //botright
					CB4Y3 = CB4Y0;
				end
			3'b010: //I Block done
				begin
				//center coords for each block
					CB1X1 = CurrBlock_X_Pos; //topleft block
					CB1Y1 = CurrBlock_Y_Pos;
					CB2X1 = CurrBlock_X_Pos;//topright block
					CB2Y1 = CurrBlock_Y_Pos-1; 
					CB3X1 = CurrBlock_X_Pos; //botleft
					CB3Y1 = CurrBlock_Y_Pos+2;
					CB4X1 = CurrBlock_X_Pos; //botright
					CB4Y1 = CurrBlock_Y_Pos+1;
					
					CB1X3 = CurrBlock_X_Pos; //topleft block
					CB1Y3 = CurrBlock_Y_Pos;
					CB2X3 = CurrBlock_X_Pos;//topright block
					CB2Y3 = CurrBlock_Y_Pos-1; 
					CB3X3 = CurrBlock_X_Pos; //botleft
					CB3Y3 = CurrBlock_Y_Pos+2;
					CB4X3 = CurrBlock_X_Pos; //botright
					CB4Y3 = CurrBlock_Y_Pos+1;

					CB1X0 = CurrBlock_X_Pos-1; //topleft block
					CB1Y0 = CurrBlock_Y_Pos;
					CB2X0 = CurrBlock_X_Pos;//topright block
					CB2Y0 = CurrBlock_Y_Pos; 
					CB3X0 = CurrBlock_X_Pos+1; //botleft
					CB3Y0 = CurrBlock_Y_Pos;
					CB4X0 = CurrBlock_X_Pos+2; //botright
					CB4Y0 = CurrBlock_Y_Pos;
					
					CB1X2 = CurrBlock_X_Pos-1; //topleft block
					CB1Y2 = CurrBlock_Y_Pos;
					CB2X2 = CurrBlock_X_Pos;//topright block
					CB2Y2 = CurrBlock_Y_Pos; 
					CB3X2 = CurrBlock_X_Pos+1; //botleft
					CB3Y2 = CurrBlock_Y_Pos;
					CB4X2 = CurrBlock_X_Pos+2; //botright
					CB4Y2 = CurrBlock_Y_Pos;
				end
			3'b011:  //T block
				begin
				//center coords for each block
					CB1X1 = CurrBlock_X_Pos; //topleft block
					CB1Y1 = CurrBlock_Y_Pos;
					CB2X1 = CurrBlock_X_Pos;//topright block
					CB2Y1 = CurrBlock_Y_Pos-1; 
					CB3X1 = CurrBlock_X_Pos; //botleft
					CB3Y1 = CurrBlock_Y_Pos+1;
					CB4X1 = CurrBlock_X_Pos+1; //botright
					CB4Y1 = CurrBlock_Y_Pos;
				
					CB1X2 = CurrBlock_X_Pos-1; //topleft block
					CB1Y2 = CurrBlock_Y_Pos;
					CB2X2 = CurrBlock_X_Pos;//topright block
					CB2Y2 = CurrBlock_Y_Pos-1; 
					CB3X2 = CurrBlock_X_Pos; //botleft
					CB3Y2 = CurrBlock_Y_Pos;
					CB4X2 = CurrBlock_X_Pos+1; //botright
					CB4Y2 = CurrBlock_Y_Pos;
		
					CB1X3 = CurrBlock_X_Pos-1; //topleft block
					CB1Y3 = CurrBlock_Y_Pos;
					CB2X3 = CurrBlock_X_Pos;//topright block
					CB2Y3 = CurrBlock_Y_Pos-1; 
					CB3X3 = CurrBlock_X_Pos; //botleft
					CB3Y3 = CurrBlock_Y_Pos+1;
					CB4X3 = CurrBlock_X_Pos; //botright
					CB4Y3 = CurrBlock_Y_Pos;
				
					CB1X0 = CurrBlock_X_Pos-1; //topleft block
					CB1Y0 = CurrBlock_Y_Pos;
					CB2X0 = CurrBlock_X_Pos;//topright block
					CB2Y0 = CurrBlock_Y_Pos; 
					CB3X0 = CurrBlock_X_Pos; //botleft
					CB3Y0 = CurrBlock_Y_Pos+1;
					CB4X0 = CurrBlock_X_Pos+1; //botright
					CB4Y0 = CurrBlock_Y_Pos;
				end
			3'b100:  //S Block done
				begin
				//center coords for each block
					CB1X1 = CurrBlock_X_Pos; //topleft block
					CB1Y1 = CurrBlock_Y_Pos;
					CB2X1 = CurrBlock_X_Pos;//topright block
					CB2Y1 = CurrBlock_Y_Pos-1; 
					CB3X1 = CurrBlock_X_Pos+1; //botleft
					CB3Y1 = CurrBlock_Y_Pos+1;
					CB4X1 = CurrBlock_X_Pos+1; //botright
					CB4Y1 = CurrBlock_Y_Pos;
					
					CB1X3 = CB1X1; //topleft block
					CB1Y3 = CB1Y1;
					CB2X3 = CB2X1;//topright block
					CB2Y3 = CB2Y1; 
					CB3X3 = CB3X1; //botleft
					CB3Y3 = CB3Y1;
					CB4X3 = CB4X1; //botright
					CB4Y3 = CB4Y1;

					
					CB1X0 = CurrBlock_X_Pos-1; //topleft block
					CB1Y0 = CurrBlock_Y_Pos+1;
					CB2X0 = CurrBlock_X_Pos;//topright block
					CB2Y0 = CurrBlock_Y_Pos; 
					CB3X0 = CurrBlock_X_Pos; //botleft
					CB3Y0 = CurrBlock_Y_Pos+1;
					CB4X0 = CurrBlock_X_Pos+1; //botright
					CB4Y0 = CurrBlock_Y_Pos;
					
					CB1X2 = CB1X0; //topleft block
					CB1Y2 = CB1Y0;
					CB2X2 = CB2X0;//topright block
					CB2Y2 = CB2Y0; 
					CB3X2 = CB3X0; //botleft
					CB3Y2 = CB3Y0;
					CB4X2 = CB4X0; //botright
					CB4Y2 = CB4Y0;
				end
			3'b101:  //Z Block done
				begin
					CB1X1 = CurrBlock_X_Pos-1; //topleft block
					CB1Y1 = CurrBlock_Y_Pos;
					CB2X1 = CurrBlock_X_Pos;//topright block
					CB2Y1 = CurrBlock_Y_Pos-1; 
					CB3X1 = CurrBlock_X_Pos-1; //botleft
					CB3Y1 = CurrBlock_Y_Pos+1;
					CB4X1 = CurrBlock_X_Pos; //botright
					CB4Y1 = CurrBlock_Y_Pos;
					
					CB1X3 = CB1X1; //topleft block
					CB1Y3 = CB1Y1;
					CB2X3 = CB2X1;//topright block
					CB2Y3 = CB2Y1; 
					CB3X3 = CB3X1; //botleft
					CB3Y3 = CB3Y1;
					CB4X3 = CB4X1; //botright
					CB4Y3 = CB4Y1;
					
					CB1X0 = CurrBlock_X_Pos-1; //topleft block
					CB1Y0 = CurrBlock_Y_Pos;
					CB2X0 = CurrBlock_X_Pos;//topright block
					CB2Y0 = CurrBlock_Y_Pos; 
					CB3X0 = CurrBlock_X_Pos; //botleft
					CB3Y0 = CurrBlock_Y_Pos+1;
					CB4X0 = CurrBlock_X_Pos+1; //botright
					CB4Y0 = CurrBlock_Y_Pos+1;

					CB1X2 = CB1X0; //topleft block
					CB1Y2 = CB1Y0;
					CB2X2 = CB2X0;//topright block
					CB2Y2 = CB2Y0; 
					CB3X2 = CB3X0; //botleft
					CB3Y2 = CB3Y0;
					CB4X2 = CB4X0; //botright
					CB4Y2 = CB4Y0;
				end
			3'b110:  //J Block
				begin
				//center coords for each block
					CB1X1 = CurrBlock_X_Pos-1; //topleft block
					CB1Y1 = CurrBlock_Y_Pos;
					CB2X1 = CurrBlock_X_Pos;//topright block
					CB2Y1 = CurrBlock_Y_Pos; 
					CB3X1 = CurrBlock_X_Pos+1; //botleft
					CB3Y1 = CurrBlock_Y_Pos+1;
					CB4X1 = CurrBlock_X_Pos+1; //botright
					CB4Y1 = CurrBlock_Y_Pos;
			
					CB1X2 = CurrBlock_X_Pos; //topleft block
					CB1Y2 = CurrBlock_Y_Pos;
					CB2X2 = CurrBlock_X_Pos;//topright block
					CB2Y2 = CurrBlock_Y_Pos-1; 
					CB3X2 = CurrBlock_X_Pos; //botleft
					CB3Y2 = CurrBlock_Y_Pos+1;
					CB4X2 = CurrBlock_X_Pos+1; //botright
					CB4Y2 = CurrBlock_Y_Pos-1;

					CB1X3 = CurrBlock_X_Pos-1; //topleft block
					CB1Y3 = CurrBlock_Y_Pos;
					CB2X3 = CurrBlock_X_Pos-1;//topright block
					CB2Y3 = CurrBlock_Y_Pos-1; 
					CB3X3 = CurrBlock_X_Pos; //botleft
					CB3Y3 = CurrBlock_Y_Pos;
					CB4X3 = CurrBlock_X_Pos+1; //botright
					CB4Y3 = CurrBlock_Y_Pos;
				
					CB1X0 = CurrBlock_X_Pos-1; //topleft block
					CB1Y0 = CurrBlock_Y_Pos+1;
					CB2X0 = CurrBlock_X_Pos;//topright block
					CB2Y0 = CurrBlock_Y_Pos-1; 
					CB3X0 = CurrBlock_X_Pos; //botleft
					CB3Y0 = CurrBlock_Y_Pos+1;
					CB4X0 = CurrBlock_X_Pos; //botright
					CB4Y0 = CurrBlock_Y_Pos;
				end
			3'b111:  //L Block
				begin
				//center coords for each block

					CB1X1 = CurrBlock_X_Pos-1; //topleft block
					CB1Y1 = CurrBlock_Y_Pos;
					CB2X1 = CurrBlock_X_Pos+1;//topright block
					CB2Y1 = CurrBlock_Y_Pos-1; 
					CB3X1 = CurrBlock_X_Pos; //botleft
					CB3Y1 = CurrBlock_Y_Pos;
					CB4X1 = CurrBlock_X_Pos+1; //botright
					CB4Y1 = CurrBlock_Y_Pos;

					CB1X2 = CurrBlock_X_Pos-1; //topleft block
					CB1Y2 = CurrBlock_Y_Pos-1;
					CB2X2 = CurrBlock_X_Pos;//topright block
					CB2Y2 = CurrBlock_Y_Pos-1; 
					CB3X2 = CurrBlock_X_Pos; //botleft
					CB3Y2 = CurrBlock_Y_Pos+1;
					CB4X2 = CurrBlock_X_Pos; //botright
					CB4Y2 = CurrBlock_Y_Pos;

					CB1X3 = CurrBlock_X_Pos-1; //topleft block
					CB1Y3 = CurrBlock_Y_Pos;
					CB2X3 = CurrBlock_X_Pos;//topright block
					CB2Y3 = CurrBlock_Y_Pos; 
					CB3X3 = CurrBlock_X_Pos-1; //botleft
					CB3Y3 = CurrBlock_Y_Pos+1;
					CB4X3 = CurrBlock_X_Pos+1; //botright
					CB4Y3 = CurrBlock_Y_Pos;
		
					CB1X0 = CurrBlock_X_Pos; //topleft block
					CB1Y0 = CurrBlock_Y_Pos;
					CB2X0 = CurrBlock_X_Pos;//topright block
					CB2Y0 = CurrBlock_Y_Pos-1; 
					CB3X0 = CurrBlock_X_Pos; //botleft
					CB3Y0 = CurrBlock_Y_Pos+1;
					CB4X0 = CurrBlock_X_Pos+1; //botright
					CB4Y0 = CurrBlock_Y_Pos+1;
				end
				3'b000:  //reset o.o
				begin
				//center coords for each block

					CB1X1 = -20; //topleft block
					CB1Y1 = -20;
					CB2X1 = -20;//topright block
					CB2Y1 = -20; 
					CB3X1 = -20; //botleft
					CB3Y1 = -20;
					CB4X1 = -20; //botright
					CB4Y1 = -20;

					CB1X2 = -20; //topleft block
					CB1Y2 = -20;
					CB2X2 = -20;//topright block
					CB2Y2 = -20; 
					CB3X2 = -20; //botleft
					CB3Y2 = -20;
					CB4X2 = -20; //botright
					CB4Y2 = -20;

					CB1X3 = -20; //topleft block
					CB1Y3 = -20;
					CB2X3 = -20;//topright block
					CB2Y3 = -20; 
					CB3X3 = -20; //botleft
					CB3Y3 = -20;
					CB4X3 = -20; //botright
					CB4Y3 = -20;
		
					CB1X0 = -20; //topleft block
					CB1Y0 = -20;
					CB2X0 = -20;//topright block
					CB2Y0 = -20; 
					CB3X0 = -20; //botleft
					CB3Y0 = -20;
					CB4X0 = -20; //botright
					CB4Y0 = -20;
				end
		endcase
	end

//start game signal o.o
always_comb
begin
startGame = 1'b0;
if(keycode != 8'h00)
	startGame = 1'b1;
end	

    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_CurrBlock
        if (Reset)  // Asynchronous Reset probably put a spawn signal here to create a new one
        begin 
            CurrBlock_Y_Motion <= 0; //CurrBlock_Y_Step;
				CurrBlock_X_Motion <= 0; //CurrBlock_X_Step;
				yCount <= 0;
				//CurrBlock_Y_Pos <= 0; //initial positions
				//CurrBlock_X_Pos <= 4;
				currRotation <= 0;
				fell <= 1;
				random <= 0;
			
				//random<= (random+1)%8;
        end
			
		 else if (fell && !gameOver) //spawn a block (basically old reset hehehe)
			begin
				CurrBlock_Y_Motion <= 0; //CurrBlock_Y_Step;
				CurrBlock_X_Motion <= 0; //CurrBlock_X_Step;
				CurrBlock_Y_Pos <= -3; //initial positions
				CurrBlock_X_Pos <= 4;
				currRotation <= 0;
				yCount <= 0;
				fell <= 0;
				random <= randomVal%7 + 1;
			end
	

		else 
        begin 
				//default cases
				CurrBlock_X_Motion <= 0; //unless we press a key dont move horizontally
				
				/*for(int i = 0; i < 20; i++)
					begin
					for(int j = 0; j< 10; j++)
						begin
						if((currBlocks[i][j] && fallenBlocks[i+1][j]) || CB3Y >= 19) //if currblock is high and fallen block below is high then stop
							begin
							CurrBlock_Y_Motion <= 0;
							fell <= 1;
							end
						end
					end*/
				//stop for interference!!!
				
				//default falling cases
				
				
				if(keycode != 8'h07) //if NOT D
						Dpressed <= 0;
				if(keycode != 8'h04) //if not A
						Apressed <= 0;
				if(keycode != 8'h1a) //if not W
						Wpressed <= 0;
				
				
				if(CB3Y <19 && !fell)
				begin
					CurrBlock_Y_Motion <= 1;  // CurrBlock is somewhere in the middle, don't bounce, just keep movinga
				end
				
				//interference cases will override the defaults
				if (CB3Y >= 19 || fallInterference ==1)// CurrBlock is at the bottom edge
				begin
					CurrBlock_Y_Motion <= 0;  //if we hit bottom edge no motion
					yCount <= (yCount + 1);  //use yCount as a temp counter variable
					if(yCount >= 60 - (difficulty*4)) //smalle yCountMax is the more difficult :)))
					begin
						fell <= 1; //at the bottom, block is fallen, but wait a damn second
						yCount <= 0;
					end
				end
					
				 case (keycode)
					8'h04 : begin //A
								if ( CB1X <= 0)  // CurrBlock is at the Left edge
										CurrBlock_X_Motion <= 0;
								else if ( fell == 1)  // CurrBlock is at the bottom edg
										CurrBlock_X_Motion <= 0;  //if we hit bottom edge no motion.
								else
									begin
									if(!Apressed && !leftInterference)
										CurrBlock_X_Motion <= -1;
										Apressed <= 1;//A means move left
									end
							  end
					        
					8'h07 : begin //D
								if ( CB4X >= 9 )  // CurrBlock is at the Right edge
									CurrBlock_X_Motion <= 0;  // cant move at the edge :c
								else if (fell == 1)  // CurrBlock is at the bottom edge
									CurrBlock_Y_Motion <= 0;  //if we hit bottom edge no motion.
								else
									begin
									if(!Dpressed && !rightInterference)
										CurrBlock_X_Motion <= 1;
									Dpressed <= 1;;//D means move right
									end
							  end

							  
					8'h16 : begin //S
								if(CB3Y >= 19)
									CurrBlock_Y_Motion <= 0;
								else if (fallInterference != 1)  // CurrBlock is at the bottom
									CurrBlock_Y_Motion <= 10;//4x faster fall
								else
									CurrBlock_Y_Motion <= 0;
							 end
							  
					8'h1A : begin //W
								//something with rotations
								if(!Wpressed && !rotInterference)
								begin
									if(currRotation == 3)
										begin
										currRotation <= 0;
										Wpressed<=1;
										end
									else begin
										currRotation <= currRotation+1;
										Wpressed <= 1;
									end
								end
							 end	
					8'h2c : begin //space
							if(CB3Y >= 19)
									CurrBlock_Y_Motion <= 0;
								else if (fallInterference != 1)  // CurrBlock is at the bottom
									CurrBlock_Y_Motion <= 10;//4x faster fall
								else
									CurrBlock_Y_Motion <= 0;
							 end
					
			
					default: ;
			   endcase
				
				//if not fallen do regular falling count
				if(!fallInterference && CB3Y < 19)
				begin
				yCount <= (yCount + CurrBlock_Y_Motion);  // Update CurrBlock y position
				if(yCount >= 60 - (difficulty*4)) //smalle yCountMax is the more difficult :)))
					begin
					CurrBlock_Y_Pos <= CurrBlock_Y_Pos + 1;
					yCount <= 0;
					end
				end
				
				CurrBlock_X_Pos <= (CurrBlock_X_Pos + CurrBlock_X_Motion);	//update X position 
		end
	 end
	 
    //check for game over
	 always_comb
	 begin
	 //fallInterference = 0;
	//CurrBlock_Y_Pos = tempCurrBlock_Y_Pos; //enums the float to a whole number so it only moves grid at a time
	 gameOver = 1'b0;
	 if(fallenBlocks[0] != 10'h000)
		gameOver = 1'b1;
	 end
	 
	 //assign currblock grd using CB coordinates
	 always_comb
	 begin
	 lineBreak = 1'b0;
	 leftInterference = 0;
	 rightInterference = 0;
	 fallInterference = 0;
	 rotInterference = 0;
	 for(int i = 0; i < 20; i++)
		begin
		
		if(fallenBlocks[i] == 10'h3ff)
			lineBreak = 1'b1;
		
		for(int j = 0; j < 10; j++)
			begin
			currBlocks[i][j] = 1'b0;
			
			if((CB1X==j && CB1Y==i) ||
				(CB2X==j && CB2Y==i) ||
				(CB3X==j && CB3Y==i) ||
				(CB4X==j && CB4Y==i))		
					currBlocks[i][j] = 1'b1;
			if(j<=8)
				begin
				if(currBlocks[i][j] && fallenBlocks[i][(j+1)])
					rightInterference = 1;
				end
			if(j>=1)
				begin
				if(currBlocks[i][j] && fallenBlocks[i][j-1])
					leftInterference = 1;
				end
			if(currBlocks[i][j] && fallenBlocks[(i+1)%20][j])
				fallInterference = 1;
			
			if(currRotation == 0)
				begin
					if(CB1X1 < 0 || CB3Y1 > 19 || CB4X1 > 9	||
					((CB1X1==j && CB1Y1==i)&&fallenBlocks[i][j]) ||
					((CB2X1==j && CB2Y1==i)&&fallenBlocks[i][j]) ||
					((CB3X1==j && CB3Y1==i)&&fallenBlocks[i][j]) ||
					((CB4X1==j && CB4Y1==i)&&fallenBlocks[i][j]))
						rotInterference = 1;
					
				end
			if(currRotation == 1)
				begin
					if(CB1X2 < 0 || CB3Y2 > 19 || CB4X2 > 9	||
					((CB1X2==j && CB1Y2==i)&&fallenBlocks[i][j]) ||
					((CB2X2==j && CB2Y2==i)&&fallenBlocks[i][j]) ||
					((CB3X2==j && CB3Y2==i)&&fallenBlocks[i][j]) ||
					((CB4X2==j && CB4Y2==i)&&fallenBlocks[i][j]))
						rotInterference = 1;
					
				end
			if(currRotation == 2)
				begin
					if(CB1X3 < 0 || CB3Y3 > 19 || CB4X3 > 9	||
					((CB1X3==j && CB1Y3==i)&&fallenBlocks[i][j]) ||
					((CB2X3==j && CB2Y3==i)&&fallenBlocks[i][j]) ||
					((CB3X3==j && CB3Y3==i)&&fallenBlocks[i][j]) ||
					((CB4X3==j && CB4Y3==i)&&fallenBlocks[i][j]))
						rotInterference = 1;
					
				end
			if(currRotation == 3)
				begin
					if(CB1X0 < 0 || CB3Y0 > 19 || CB4X0 > 9	||
					((CB1X0==j && CB1Y0==i)&&fallenBlocks[i][j]) ||
					((CB2X0==j && CB2Y0==i)&&fallenBlocks[i][j]) ||
					((CB3X0==j && CB3Y0==i)&&fallenBlocks[i][j]) ||
					((CB4X0==j && CB4Y0==i)&&fallenBlocks[i][j]))
						rotInterference = 1;
					
				end
	
			end
		end
    end

endmodule 


/*
//the midpoint test
module  CurrBlock ( input Reset, frame_clk,
					//input logic [2:0] random,
					input [7:0] keycode, 
					output fell,
               output [9:0]  CurrBlock1X, CurrBlock1Y, BlockS, 
					output [9:0]  CurrBlock2X, CurrBlock2Y,
					output [9:0]  CurrBlock3X, CurrBlock3Y,
					output [9:0]  CurrBlock4X, CurrBlock4Y);
    
	 //current center position of the center block and block motion
    logic [9:0] CurrBlock_X_Pos, CurrBlock_X_Motion,CurrBlock_Y_Pos,CurrBlock_Y_Motion,Block_Size;
	 logic [9:0] CB1X,CB1Y,CB2X,CB2Y,CB3X,CB3Y,CB4X,CB4Y; //CURRENT position for each block
	 
	 //center position is initial position, top center of screen for curr block
    parameter [9:0] CurrBlock_X_Center=320;  // Center position on the X axis
    parameter [9:0] CurrBlock_Y_Center=0;  // Center position on the Y axis  CB1X???
    parameter [9:0] CurrBlock_X_Min=200;       // Leftmost point on the X axis
    parameter [9:0] CurrBlock_X_Max=439;     // Rightmost point on the X axis
    parameter [9:0] CurrBlock_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] CurrBlock_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] CurrBlock_X_Step=24;      // Step size on the X axis (one coordinates worth)
    parameter [9:0] CurrBlock_Y_Step=1;      // Step size on the Y axis (just 1 so it can slowly fall)
	 
	 
	 //intermediate logic for the keys
	 logic Apressed, Wpressed, Dpressed;
	 logic [1:0] currRotation;
	 logic [2:0] random = 3'b001;
	 
	 
	assign Block_Size = 12;	//each block is 24x24 pixels so 12 is half of that (because center +12 is half square)
	always_comb
	begin
	//default values
		CB1X = 0; //topleft block
		CB1Y = 0;
		CB2X = 0;//topright block
		CB2Y = 0; 
		CB3X = 0; //botleft
		CB3Y = 0;
		CB4X = 0; //botright
		CB4Y = 0;
	//have CB1x be the LEFTMOST block (so we dont need to check all of them)
	//CB4X will be the RIGHTMOST block
	//CB2Y will be the TOPMOST BLOCK
	//CB3Y will be the BOTTOM MOST block
		case(random)
			3'b000: //empty
				begin
					CB1X = CurrBlock_X_Pos; //topleft block
					CB1Y = CurrBlock_Y_Pos;
					CB2X = CurrBlock_X_Pos;//topright block
					CB2Y = CurrBlock_Y_Pos-24; 
					CB3X = CurrBlock_X_Pos; //botleft
					CB3Y = CurrBlock_Y_Pos+48;
					CB4X = CurrBlock_X_Pos; //botright
					CB4Y = CurrBlock_Y_Pos+24;
					end
			3'b001: //OBlock
				begin
				//center coords for each block
					CB1X = CurrBlock_X_Pos; //topleft block
					CB1Y = CurrBlock_Y_Pos;
					CB2X = CurrBlock_X_Pos+24;//topright block
					CB2Y = CurrBlock_Y_Pos; 
					CB3X = CurrBlock_X_Pos; //botleft
					CB3Y = CurrBlock_Y_Pos+24;
					CB4X = CurrBlock_X_Pos+24; //botright
					CB4Y = CurrBlock_Y_Pos+24;
				end
			3'b010: //I Block
				begin
				//center coords for each block
				if((currRotation%2)==1)
					begin
					CB1X = CurrBlock_X_Pos; //topleft block
					CB1Y = CurrBlock_Y_Pos;
					CB2X = CurrBlock_X_Pos;//topright block
					CB2Y = CurrBlock_Y_Pos-24; 
					CB3X = CurrBlock_X_Pos; //botleft
					CB3Y = CurrBlock_Y_Pos+48;
					CB4X = CurrBlock_X_Pos; //botright
					CB4Y = CurrBlock_Y_Pos+24;
					end
				else
					begin
					CB1X = CurrBlock_X_Pos-24; //topleft block
					CB1Y = CurrBlock_Y_Pos;
					CB2X = CurrBlock_X_Pos;//topright block
					CB2Y = CurrBlock_Y_Pos; 
					CB3X = CurrBlock_X_Pos+24; //botleft
					CB3Y = CurrBlock_Y_Pos;
					CB4X = CurrBlock_X_Pos+48; //botright
					CB4Y = CurrBlock_Y_Pos;
					end
				end
			3'b011:  //T block
				begin
				//center coords for each block
					CB1X = CurrBlock_X_Pos-24; //topleft block
					CB1Y = CurrBlock_Y_Pos;
					CB2X = CurrBlock_X_Pos;//topright block
					CB2Y = CurrBlock_Y_Pos; 
					CB3X = CurrBlock_X_Pos; //botleft
					CB3Y = CurrBlock_Y_Pos+24;
					CB4X = CurrBlock_X_Pos+24; //botright
					CB4Y = CurrBlock_Y_Pos;
				end
			3'b100:  //S Block
				begin
				//center coords for each block
					CB1X = CurrBlock_X_Pos-24; //topleft block
					CB1Y = CurrBlock_Y_Pos+24;
					CB2X = CurrBlock_X_Pos;//topright block
					CB2Y = CurrBlock_Y_Pos; 
					CB3X = CurrBlock_X_Pos; //botleft
					CB3Y = CurrBlock_Y_Pos+24;
					CB4X = CurrBlock_X_Pos+24; //botright
					CB4Y = CurrBlock_Y_Pos;
				end
			3'b101:  //Z Block
				begin
				//center coords for each block
					CB1X = CurrBlock_X_Pos-24; //topleft block
					CB1Y = CurrBlock_Y_Pos;
					CB2X = CurrBlock_X_Pos;//topright block
					CB2Y = CurrBlock_Y_Pos; 
					CB3X = CurrBlock_X_Pos; //botleft
					CB3Y = CurrBlock_Y_Pos+24;
					CB4X = CurrBlock_X_Pos+24; //botright
					CB4Y = CurrBlock_Y_Pos+24;
				end
			3'b110:  //J Block
				begin
				//center coords for each block
					CB1X = CurrBlock_X_Pos-24; //topleft block
					CB1Y = CurrBlock_Y_Pos;
					CB2X = CurrBlock_X_Pos;//topright block
					CB2Y = CurrBlock_Y_Pos-48; 
					CB3X = CurrBlock_X_Pos; //botleft
					CB3Y = CurrBlock_Y_Pos;
					CB4X = CurrBlock_X_Pos; //botright
					CB4Y = CurrBlock_Y_Pos-24;
				end
			3'b111:  //L Block
				begin
				//center coords for each block
					CB1X = CurrBlock_X_Pos; //topleft block
					CB1Y = CurrBlock_Y_Pos-24;
					CB2X = CurrBlock_X_Pos;//topright block
					CB2Y = CurrBlock_Y_Pos-48; 
					CB3X = CurrBlock_X_Pos; //botleft
					CB3Y = CurrBlock_Y_Pos;
					CB4X = CurrBlock_X_Pos+24; //botright
					CB4Y = CurrBlock_Y_Pos;
				end
			default : ;
		endcase
	end
	
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_CurrBlock
        if (Reset)  // Asynchronous Reset probably put a spawn signal here to create a new one
        begin 
            CurrBlock_Y_Motion <= 10'd1; //CurrBlock_Y_Step;
				CurrBlock_X_Motion <= 10'd0; //CurrBlock_X_Step;
				CurrBlock_Y_Pos <= CurrBlock_Y_Center; //initial positions
				CurrBlock_X_Pos <= CurrBlock_X_Center;
				currRotation <= 0;
				random<= (random+1)%8;
				if (random ==7)
					random<= 1;
        end
           
        else 
        begin 
				//default cases
				CurrBlock_X_Motion <= 0; //unless we press a key dont move
				if(Dpressed)
					Dpressed <= 0;
				if(Apressed)
				Apressed <= 0;
				if(Wpressed)
					Wpressed <= 0;
				if ( (CB3Y + Block_Size) >= CurrBlock_Y_Max )// CurrBlock is at the bottom edge
					begin
									CurrBlock_Y_Motion <= 0;  //if we hit bottom edge no motion
									fell = 1; //we are at the bottom, so this block is considered fallen
					end
				 else 
					begin
					  CurrBlock_Y_Motion <= 1;  // CurrBlock is somewhere in the middle, don't bounce, just keep moving
					  fell = 0;
					end
				 case (keycode)
					8'h04 : begin //A
								if ( (CB1X - Block_Size) <= CurrBlock_X_Min )  // CurrBlock is at the Left edge
									begin
										CurrBlock_X_Motion <= 0;
										Apressed <= 0;
									end
								else if ( (CB3Y + Block_Size) >= CurrBlock_Y_Max )  // CurrBlock is at the bottom edge
									begin
										CurrBlock_X_Motion <= 0;  //if we hit bottom edge no motion.
										Apressed <= 0;
									end
								else
									Apressed <= 1;//A
							  end
					        
					8'h07 : begin //D
								if ( (CB4X + Block_Size) >= CurrBlock_X_Max )  // CurrBlock is at the Right edge
									begin
									CurrBlock_X_Motion <= 0;  // cant move at the edge :c
									Dpressed <= 0;
									end
								else if ( (CB3Y + Block_Size) >= CurrBlock_Y_Max )  // CurrBlock is at the bottom edge
									begin
									CurrBlock_Y_Motion <= 0;  //if we hit bottom edge no motion.
									Dpressed <= 0;
									end
								else
									Dpressed <= 1;;//D
							  end

							  
					8'h16 : begin //S
								if ( (CB3Y + Block_Size) >= CurrBlock_Y_Max )  // CurrBlock is at the bottom edge
									CurrBlock_Y_Motion <= 0;  //if we hit bottom edge no motion.
								else
									CurrBlock_Y_Motion <= 3;
							 end
							  
					8'h1A : begin //W
								//something with rotations
								Wpressed <= 1;
							 end	
					default: ;
			   endcase
				 
				CurrBlock_Y_Pos <= (CurrBlock_Y_Pos + CurrBlock_Y_Motion);  // Update CurrBlock position
				if(Apressed)
					CurrBlock_X_Pos <= (CurrBlock_X_Pos - 24);
				else if(Dpressed)
					CurrBlock_X_Pos <= (CurrBlock_X_Pos + 24);
				else
				 CurrBlock_X_Pos <= (CurrBlock_X_Pos + CurrBlock_X_Motion);	
				 
				if(Wpressed)
					currRotation <= (currRotation+1)%4;
		end  
    end
    //assign currblocks
    assign CurrBlock1X = CB1X;
    assign CurrBlock1Y = CB1Y;
	 assign CurrBlock2X = CB2X;
    assign CurrBlock2Y = CB2Y;
	 assign CurrBlock3X = CB3X;
    assign CurrBlock3Y = CB3Y;
	 assign CurrBlock4X = CB4X;
    assign CurrBlock4Y = CB4Y;
    assign BlockS = Block_Size;
    

endmodule 
*/


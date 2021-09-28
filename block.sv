//-------------------------------------------------------------------------
//    CurrBlock.sv
// will probably make an sv file for one of the four pixels                                                                                            --
//-------------------------------------------------------------------------


module  CurrBlock ( input Reset, frame_clk,
					input logic [2:0] random,
					input logic [1:0] rotation, //4 rotation patterns o.o
					input [7:0] keycode, /*we need:
												left/right for left right shift (already implemented)
												up for rotations (rot + 1)
												down for accelerating (low prio)
												space for instant drop*/
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
			3'b000: ;//empty
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
			3'b010: ;
			3'b011: ;
			3'b100: ;
			3'b101: ;
			3'b110: ;
			3'b111: ;
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
        end
           
        else 
        begin 
				//default cases
				CurrBlock_X_Motion <= 0; //unless we press a key dont move
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
					8'h04 : begin
								if ( (CB1X - Block_Size) <= CurrBlock_X_Min )  // CurrBlock is at the Left edge
									CurrBlock_X_Motion <= 0;
								else
									CurrBlock_X_Motion <= -24;//A
							  end
					        
					8'h07 : begin
								if ( (CB4X + Block_Size) >= CurrBlock_X_Max )  // CurrBlock is at the Right edge
									CurrBlock_X_Motion <= 0;  // cant move at the edge :c
								else
									CurrBlock_X_Motion <= 24;//D
							  end

							  
					8'h16 : begin //S
								if ( (CB3Y + Block_Size) >= CurrBlock_Y_Max )  // CurrBlock is at the bottom edge
									CurrBlock_Y_Motion <= 0;  //if we hit bottom edge no motion.
								else
									CurrBlock_Y_Motion <= 3;
							 end
							  
					8'h1A : begin //W
								//something with rotations
							 end	
					default: ;
			   endcase
				 
				 CurrBlock_Y_Pos <= (CurrBlock_Y_Pos + CurrBlock_Y_Motion);  // Update CurrBlock position
				 CurrBlock_X_Pos <= (CurrBlock_X_Pos + CurrBlock_X_Motion);	
		end  
    end
       
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

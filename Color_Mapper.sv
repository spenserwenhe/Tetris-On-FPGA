//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] DrawX, DrawY, difficulty,
								input logic [5:0] Xpos, Ypos,
								input logic [9:0] currBlocks [19:0],
								input logic [9:0] fallenBlocks [19:0],
								input logic [2:0] shape, //shape of block 
                       output logic [7:0]  Red, Green, Blue);
    
    logic CBlockOn;
	 logic FBlockOn;
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    //int DistX, DistY, Size;
	 //assign DistX = DrawX - BallX;
    //assign DistY = DrawY - BallY;
	 //assign fallenBlocksGrid = fallenBlocks;
	 //assign currBlocksGrid = currBlocks;
	
	always_comb
	 begin:grid_iteration
	 //for loops only do the last fricking one
	 FBlockOn = 1'b0;
	 CBlockOn = 1'b0;
		for(int i = 0; i < 20; i++)
		begin
			for(int j = 0; j<10; j++)
			begin
				if((DrawX >= 200+24*j) &&
				(DrawX <= 223+24*j) &&
				(DrawY >= 24*i) &&
				(DrawY <= 23+24*i))
				begin
					if(currBlocks[i][j])
						CBlockOn = 1'b1;
					if(fallenBlocks[i][j])
						FBlockOn = 1'b1;
				end
			end
		end
	 end
	  
    /*always_comb
    begin:Ball_on_proc
    /*    if ((DrawX >= CBlock1X - Size) &&
       (DrawX <= CBlock1X + Size) &&
       (DrawY >= CBlock1Y - Size) &&
       (DrawY <= CBlock1Y + Size))
			CBlockOn = 1'b1;
		else if((DrawX >= CBlock2X - Size) &&
       (DrawX <= CBlock2X + Size) &&
       (DrawY >= CBlock2Y - Size) &&
       (DrawY <= CBlock2Y + Size))
			CBlockOn = 1'b1;
		else if((DrawX >= CBlock3X - Size) &&
       (DrawX <= CBlock3X + Size) &&
       (DrawY >= CBlock3Y - Size) &&
       (DrawY <= CBlock3Y + Size))
			CBlockOn = 1'b1;
		else if((DrawX >= CBlock4X - Size) &&
       (DrawX <= CBlock4X + Size) &&
       (DrawY >= CBlock4Y - Size) &&
       (DrawY <= CBlock4Y + Size))
			CBlockOn = 1'b1;
		else
			CBlockOn = 1'b0;
	 end*/

       
    always_comb
    begin:RGB_Display
			//fallen blocks
			if ((FBlockOn == 1'b1)) 
        begin 
            Red = 8'h8f*+(difficulty*10);
            Green = 8'h8f;
            Blue = 8'h9f;
        end   
		  //current block
        else if ((CBlockOn == 1'b1)) 
        begin 
			if(shape == 1)
				begin
            Red = 8'hf1;
            Green = 8'hf1;
            Blue = 8'h00;
				end
			else if(shape == 2)
				begin
            Red = 8'h00;
            Green = 8'hef;
            Blue = 8'hf1;
				end
			else if(shape == 3)
				begin
            Red = 8'ha0;
            Green = 8'h00;
            Blue = 8'hf2;
				end
			else if(shape == 4)
				begin
            Red = 8'h01;
            Green = 8'hef;
            Blue = 8'h00;
				end
			else if(shape == 5)
				begin
            Red = 8'hf2;
            Green = 8'h00;
            Blue = 8'h00;
				end
			else if(shape == 6)
				begin
            Red = 8'hf2;
            Green = 8'h9f;
            Blue = 8'h03;
				end
			else //shape ==7
				begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'hf0;
				end
        end       
		  
        else if((DrawX >=200)&& //gameboard
					(DrawX <= 439))
				begin
				Red = 8'h00; 
				Green = 8'h00;
				Blue = 8'h00;
				end
			else //background
			begin
				Red = 8'h11 - DrawY[4:1]*Ypos/5;// + DrawY[7:4];
				Green = 8'h00*Xpos/4;// + DrawY[7:4];
				Blue = 8'h88 - DrawY[9:3]*Ypos/2;// + DrawY[9:0];
			end      
    end 
endmodule

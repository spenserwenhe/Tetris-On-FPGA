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


module  color_mapper ( input        [9:0] DrawX, DrawY, Block_size,
								input logic [9:0] CBlock1X,CBlock1Y,
								input logic [9:0]	CBlock2X,CBlock2Y,
								input logic [9:0]	CBlock3X,CBlock3Y,
								input logic [9:0]	CBlock4X,CBlock4Y,
                       output logic [7:0]  Red, Green, Blue );
    
    logic CBlockOn;
	 
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
	  
    int DistX, DistY, Size;
	 //assign DistX = DrawX - BallX;
    //assign DistY = DrawY - BallY;
    assign Size = Block_size;
	  
    always_comb
    begin:Ball_on_proc
        if ((DrawX >= CBlock1X - Size) &&
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
     end 
       
    always_comb
    begin:RGB_Display
        if ((CBlockOn == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'h55;
            Blue = 8'h00;
        end       
        else //background
        begin 
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h7f - DrawX[9:3];
        end      
    end 
    
endmodule

//linebreak module

module lineBreak(input clk, lineBreakMode,reset,//max10 clock 
                input [9:0] fallenBlocks [19:0],
                output [9:0] lineBroken [19:0],
					 output [9:0] difficulty);

//intermediate logic and integers
int rowCount;
logic [9:0] difficultyScore;
assign difficulty = difficultyScore;

always_ff @ (posedge clk)
begin
    lineBroken <= fallenBlocks; //default case when not in linebreakmode
    if(reset)
		difficultyScore <= 10'h000;
	 if(lineBreakMode)
        begin
            if(fallenBlocks[19] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[19] <= fallenBlocks[18];
                lineBroken[18] <= fallenBlocks[17];
                lineBroken[17] <= fallenBlocks[16];
                lineBroken[16] <= fallenBlocks[15];
                lineBroken[15] <= fallenBlocks[14];
                lineBroken[14] <= fallenBlocks[13];
                lineBroken[13] <= fallenBlocks[12];
                lineBroken[12] <= fallenBlocks[11];
                lineBroken[11] <= fallenBlocks[10];
                lineBroken[10] <= fallenBlocks[9];
                lineBroken[9] <= fallenBlocks[8];
                lineBroken[8] <= fallenBlocks[7];
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[18] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[18] <= fallenBlocks[17];
                lineBroken[17] <= fallenBlocks[16];
                lineBroken[16] <= fallenBlocks[15];
                lineBroken[15] <= fallenBlocks[14];
                lineBroken[14] <= fallenBlocks[13];
                lineBroken[13] <= fallenBlocks[12];
                lineBroken[12] <= fallenBlocks[11];
                lineBroken[11] <= fallenBlocks[10];
                lineBroken[10] <= fallenBlocks[9];
                lineBroken[9] <= fallenBlocks[8];
                lineBroken[8] <= fallenBlocks[7];
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[17] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[17] <= fallenBlocks[16];
                lineBroken[16] <= fallenBlocks[15];
                lineBroken[15] <= fallenBlocks[14];
                lineBroken[14] <= fallenBlocks[13];
                lineBroken[13] <= fallenBlocks[12];
                lineBroken[12] <= fallenBlocks[11];
                lineBroken[11] <= fallenBlocks[10];
                lineBroken[10] <= fallenBlocks[9];
                lineBroken[9] <= fallenBlocks[8];
                lineBroken[8] <= fallenBlocks[7];
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[16] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[16] <= fallenBlocks[15];
                lineBroken[15] <= fallenBlocks[14];
                lineBroken[14] <= fallenBlocks[13];
                lineBroken[13] <= fallenBlocks[12];
                lineBroken[12] <= fallenBlocks[11];
                lineBroken[11] <= fallenBlocks[10];
                lineBroken[10] <= fallenBlocks[9];
                lineBroken[9] <= fallenBlocks[8];
                lineBroken[8] <= fallenBlocks[7];
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[15] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[15] <= fallenBlocks[14];
                lineBroken[14] <= fallenBlocks[13];
                lineBroken[13] <= fallenBlocks[12];
                lineBroken[12] <= fallenBlocks[11];
                lineBroken[11] <= fallenBlocks[10];
                lineBroken[10] <= fallenBlocks[9];
                lineBroken[9] <= fallenBlocks[8];
                lineBroken[8] <= fallenBlocks[7];
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[14] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[14] <= fallenBlocks[13];
                lineBroken[13] <= fallenBlocks[12];
                lineBroken[12] <= fallenBlocks[11];
                lineBroken[11] <= fallenBlocks[10];
                lineBroken[10] <= fallenBlocks[9];
                lineBroken[9] <= fallenBlocks[8];
                lineBroken[8] <= fallenBlocks[7];
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[13] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[13] <= fallenBlocks[12];
                lineBroken[12] <= fallenBlocks[11];
                lineBroken[11] <= fallenBlocks[10];
                lineBroken[10] <= fallenBlocks[9];
                lineBroken[9] <= fallenBlocks[8];
                lineBroken[8] <= fallenBlocks[7];
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[12] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[12] <= fallenBlocks[11];
                lineBroken[11] <= fallenBlocks[10];
                lineBroken[10] <= fallenBlocks[9];
                lineBroken[9] <= fallenBlocks[8];
                lineBroken[8] <= fallenBlocks[7];
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[11] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[11] <= fallenBlocks[10];
                lineBroken[10] <= fallenBlocks[9];
                lineBroken[9] <= fallenBlocks[8];
                lineBroken[8] <= fallenBlocks[7];
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[10] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[10] <= fallenBlocks[9];
                lineBroken[9] <= fallenBlocks[8];
                lineBroken[8] <= fallenBlocks[7];
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[9] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[9] <= fallenBlocks[8];
                lineBroken[8] <= fallenBlocks[7];
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[8] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[8] <= fallenBlocks[7];
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[7] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[7] <= fallenBlocks[6];
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[6] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[6] <= fallenBlocks[5];
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[5] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[5] <= fallenBlocks[4];
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[4] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[4] <= fallenBlocks[3];
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[3] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[3] <= fallenBlocks[2];
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[2] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[2] <= fallenBlocks[1];
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
            else if(fallenBlocks[1] == 10'hfff)
                begin
					 difficultyScore <= difficultyScore + 1;
                lineBroken[1] <= fallenBlocks[0];
                lineBroken[0] <= 10'd0;
                end
        end
end


endmodule

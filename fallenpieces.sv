//fallenpieces.sv

module fallenpieces(input logic fallen, reset, clk, lineBreak,
							input logic [9:0] currBlocks[19:0],//20 paths 10 bits each
							input logic [9:0] lineBroken [19:0],
							output logic [9:0] fallenBlocks[19:0]);

//logic [24] block [24];							
//logic [10] grid [20];

int multiLineBreak, tempCount, tempHolder;
logic [9:0] nextfallenBlocksGrid[19:0]; //the next iteration
//int fallenBlocksGrid [19:0][9:0] = fallenBlocks;
//int currBlocksGrid [19:0][9:0] = currBlocks;

always_ff @ (posedge clk)
begin
	fallenBlocks = nextfallenBlocksGrid;

	/*if(lineBreak)
	begin
		if(tempHolder != 0) //downshift, we have something held
			begin
			if(tempCount == 0)
				tempHolder <= 0;
				tempCount <= 19;
			fallenBlocks[tempCount] <= fallenBlocks[tempCount - 1];
			tempCount <= tempCount - 1;
			end
		else if(fallenBlocks[tempCount] == 10'h000)
			begin
			tempHolder <= tempCount; //the identified empty row
			end
		else
			tempCount <= tempCount - 1;
	end*/

end							
							
always_comb
begin
	//default next iteration = previous iteration
	nextfallenBlocksGrid = fallenBlocks;
	
	if (reset)
	begin
		nextfallenBlocksGrid[19] = 10'h000;
		nextfallenBlocksGrid[18] = 10'h000;
		nextfallenBlocksGrid[17] = 10'h000;
		nextfallenBlocksGrid[16] = 10'h000;
		nextfallenBlocksGrid[15] = 10'h000;
		nextfallenBlocksGrid[14] = 10'h000;
		nextfallenBlocksGrid[13] = 10'h000;
		nextfallenBlocksGrid[12] = 10'h000;
		nextfallenBlocksGrid[11] = 10'h000;
		nextfallenBlocksGrid[10] = 10'h000;
		nextfallenBlocksGrid[9] = 10'h000;
		nextfallenBlocksGrid[8] = 10'h000;
		nextfallenBlocksGrid[7] = 10'h000;
		nextfallenBlocksGrid[6] = 10'h000;
		nextfallenBlocksGrid[5] = 10'h000;
		nextfallenBlocksGrid[4] = 10'h000;
		nextfallenBlocksGrid[3] = 10'h000;
		nextfallenBlocksGrid[2] = 10'h000;
		nextfallenBlocksGrid[1] = 10'h000;
		nextfallenBlocksGrid[0] = 10'h000;
	end
	
	
	
	else if(lineBreak)
	begin
		//tempCount = 19;
		//tempHolder = 0;
		nextfallenBlocksGrid[19] = lineBroken[19];
		nextfallenBlocksGrid[18] = lineBroken[18];
		nextfallenBlocksGrid[17] = lineBroken[17];
		nextfallenBlocksGrid[16] = lineBroken[16];
		nextfallenBlocksGrid[15] = lineBroken[15];
		nextfallenBlocksGrid[14] = lineBroken[14];
		nextfallenBlocksGrid[13] = lineBroken[13];
		nextfallenBlocksGrid[12] = lineBroken[12];
		nextfallenBlocksGrid[11] = lineBroken[11];
		nextfallenBlocksGrid[10] = lineBroken[10];
		nextfallenBlocksGrid[9] = lineBroken[9];
		nextfallenBlocksGrid[8] = lineBroken[8];
		nextfallenBlocksGrid[7] = lineBroken[7];
		nextfallenBlocksGrid[6] = lineBroken[6];
		nextfallenBlocksGrid[5] = lineBroken[5];
		nextfallenBlocksGrid[4] = lineBroken[4];
		nextfallenBlocksGrid[3] = lineBroken[3];
		nextfallenBlocksGrid[2] = lineBroken[2];
		nextfallenBlocksGrid[1] = lineBroken[1];
		nextfallenBlocksGrid[0] = lineBroken[0];
	end
	
	
	
	/*begin
		for(int i = 19; i > 0; i--)
		begin
			if(fallenBlocks[i] == 10'hfff)
				begin
					for(int j = i; j > (19-i); j--)
					nextfallenBlocksGrid[j] = nextfallenBlocksGrid[j-1];
				end
		end
	end*/
	
	else if(fallen)
		begin
			nextfallenBlocksGrid[19] = {currBlocks[19][9:0]|fallenBlocks[19][9:0]};
			nextfallenBlocksGrid[18] = {currBlocks[18][9:0]|fallenBlocks[18][9:0]};
			nextfallenBlocksGrid[17] = {currBlocks[17][9:0]|fallenBlocks[17][9:0]};
			nextfallenBlocksGrid[16] = {currBlocks[16][9:0]|fallenBlocks[16][9:0]};
			nextfallenBlocksGrid[15] = {currBlocks[15][9:0]|fallenBlocks[15][9:0]};
			nextfallenBlocksGrid[14] = {currBlocks[14][9:0]|fallenBlocks[14][9:0]};
			nextfallenBlocksGrid[13] = {currBlocks[13][9:0]|fallenBlocks[13][9:0]};
			nextfallenBlocksGrid[12] = {currBlocks[12][9:0]|fallenBlocks[12][9:0]};
			nextfallenBlocksGrid[11] = {currBlocks[11][9:0]|fallenBlocks[11][9:0]};
			nextfallenBlocksGrid[10] = {currBlocks[10][9:0]|fallenBlocks[10][9:0]};
			nextfallenBlocksGrid[9] =  {currBlocks[9][9:0] |fallenBlocks[9][9:0]};
			nextfallenBlocksGrid[8] =  {currBlocks[8][9:0] |fallenBlocks[8][9:0]};
			nextfallenBlocksGrid[7] =  {currBlocks[7][9:0] |fallenBlocks[7][9:0]};
			nextfallenBlocksGrid[6] =  {currBlocks[6][9:0] |fallenBlocks[6][9:0]};
			nextfallenBlocksGrid[5] =  {currBlocks[5][9:0] |fallenBlocks[5][9:0]};
			nextfallenBlocksGrid[4] =  {currBlocks[4][9:0] |fallenBlocks[4][9:0]};
			nextfallenBlocksGrid[3] =  {currBlocks[3][9:0] |fallenBlocks[3][9:0]};
			nextfallenBlocksGrid[2] =  {currBlocks[2][9:0] |fallenBlocks[2][9:0]};
			nextfallenBlocksGrid[1] =  {currBlocks[1][9:0] |fallenBlocks[1][9:0]};
			nextfallenBlocksGrid[0] =  {currBlocks[0][9:0] |fallenBlocks[0][9:0]};
		end
end

endmodule

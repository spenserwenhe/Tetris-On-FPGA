//testbench.sv
module testbench();

logic frame_clk = 0;
logic clk, Reset, Spawn;
logic [7:0] keycode;
logic [9:0] difficulty;
logic [9:0] fallenBlocks [19:0];
logic fell, gameOver, startGame, lineBreak;
logic [2:0] shape;
logic [5:0] Xpos, Ypos;
logic [9:0] currBlocks [19:0];

CurrBlock currentblockInstance0(.*);
assign rando = currentblockInstance0.random;
assign rotation = currentblockInstance0.currRotation;

always begin: CLOCK_GENERATION
#1 frame_clk = ~frame_clk;
end

initial begin: CLOCK_INITIALIZATION
	frame_clk = 0;
end

initial begin: TEST_VECTORS
rando = 3'b011; //T block for example
rotation = 0;

#20 Reset = 1'b1;
#2 Reset = 1'b0;
#4 rotation = 1;
#4 keycode = 8'h04;

end
endmodule
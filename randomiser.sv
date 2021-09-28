//
// randomizer.sv so we get random CurrBlocks
//
/*
module randomiser(input logic clk,
						output logic [2:0] random);
						

logic [2:0] next;
	
always_ff @ (posedge clk)
begin
		random <= next;
end

always_comb
begin
	if (seed == 7)
		random = 0;
	else 
		next = random+1;
end

endmodule
*/

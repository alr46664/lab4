//Bloco TOP

module processador(
	// input [31:0] instr, 
	output [31:0] out,
	output [31:0] ans,
	input reset,
	input clk);
	
	wire count;
	wire [4:0] ALUOp;
	wire [3:0] op;
	
	// sinais de sontrole
	wire RegDst, ALUSrc, Mem2Reg, MemRead, MemWrite, PCSrc;

endmodule

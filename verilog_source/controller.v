module controller(
	opcode,   // opcode
	ctrl     // saida do controller
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada / saida
input [OPCODE_WIDTH-1:0] opcode;

output reg [CTRL_WIDTH-1:0] ctrl;

// gera o sinal ctrl
always @(opcode) begin
	// TODO (talvez precisemos mudar isso aqui)
	ctrl <= opcode[CTRL_WIDTH-1:0];
end

endmodule
module pipeline2(
	clk_in,    // clock_in
	RST,       // reset
	instr,     // instrucao
	reg_addr,  // endereco do registrador a ser gravado
	reg_data,  // dados a serem gravados no registrador reg_addr
	reg_en,    // habilita gravacao de reg_data em reg_addr no banco de registradores
    A,         // dados do registrador 1
    B,         // dados do registrador 2
    imm,       // immediato
    ctrl,      // saida - controller do processador,
    clk_out    // saida clk out
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada / saida
input clk_in, RST;
input [INSTR_WIDTH-1:0] instr;
input [REG_ADDR_WIDTH-1:0] reg_addr;
input [DATA_WIDTH-1:0] reg_data;
input reg_en;

output reg signed [DATA_WIDTH-1:0] imm;
output signed [DATA_WIDTH-1:0] A, B;
output [CTRL_WIDTH-1:0] ctrl;
output clk_out;

// variaveis auxiliares
reg [REG_ADDR_WIDTH-1:0] instr_reg1, instr_reg2;
reg [OPCODE_WIDTH-1:0] opcode;
// clock negado para sincronizar os blocos ctrl0 e regs0
// com o pipeline2
wire clk_neg;

// instanciacao do controller e do banco de registradores
controller ctrl0(.opcode(opcode), .ctrl(ctrl));
regs regs0(.clk(clk_neg), .en_write(reg_en), .addr_write(reg_addr), .data_write(reg_data), .addr_read1(instr_reg1), .addr_read2(instr_reg2), .data_read1(A), .data_read2(B));

// decodifique a instrucao
always @(posedge clk_in or negedge RST) begin
	if (RST) begin
		opcode      <= instr[OPCODE_WIDTH-1:0];
		instr_reg1  <= instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH];
		instr_reg2  <= instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH];
		imm         <= instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2];
	end	else begin
		// rotina de reset
		opcode      <= NOP;
		instr_reg1  <= 0;
		instr_reg2  <= 0;
		imm         <= 0;
	end
end

// salva os dados reg_data no registrador reg_addr,
// faz leitura dos registradores,
// gera o sinal ctrl,
assign clk_neg = !clk_in;

// gera clk_out indicando dados de saida estaveis
assign clk_out = clk_in;

endmodule
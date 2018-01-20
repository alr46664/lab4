module pipeline2(
	clk_in,    // clock_in
	RST,       // reset
	pc_in,     // entrada - contador de programa
	instr,     // instrucao
	reg_addr,  // endereco do registrador a ser gravado
	reg_data,  // dados a serem gravados no registrador reg_addr
	reg_en,    // habilita gravacao de reg_data em reg_addr no banco de registradores
    A_addr,    // endereco do registrador 1
    B_addr,    // endereco do registrador 2
    A,         // dados do registrador 1
    B,         // dados do registrador 2
    imm,       // immediato
	pc_out,    // saida - contador de programa
    ctrl      // saida - controller do processador,
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada / saida
input clk_in, RST;
input [PC_WIDTH-1:0] pc_in;
input [INSTR_WIDTH-1:0] instr;
input [REG_ADDR_WIDTH-1:0] reg_addr;
input [DATA_WIDTH-1:0] reg_data;
input reg_en;

output reg signed [DATA_WIDTH-1:0] imm;
output reg [PC_WIDTH-1:0] pc_out;
output reg [REG_ADDR_WIDTH-1:0] A_addr, B_addr;
output signed [DATA_WIDTH-1:0] A, B;
output [CTRL_WIDTH-1:0] ctrl;

// variaveis auxiliares
reg [OPCODE_WIDTH-1:0] opcode;
wire clk_neg;

// instanciacao do controller e do banco de registradores
controller ctrl0(.opcode(opcode), .ctrl(ctrl));
regs regs0(.clk(clk_neg),
         .en_write(reg_en), .addr_write(reg_addr), .data_write(reg_data),
         .addr_read1(A_addr), .addr_read2(B_addr),
         .data_read1(A), .data_read2(B));

assign clk_neg = ~clk_in;
		 
// decodifique a instrucao e
// gera done indicando dados de saida estaveis
always @(posedge clk_in) begin
	if (!RST) begin
		// rotina de reset
		opcode      <= NOP;
		A_addr      <= 0;
		B_addr      <= 0;
		imm         <= 0;
		// reset - PC vai pro valor inicial
		pc_out      <= PC_INITIAL + 1;
	end	else begin
		opcode      <= instr[OPCODE_WIDTH-1:0];
		A_addr      <= instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH];
		B_addr      <= instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH];
		imm         <= instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2];
		// se opcode == RET, entao leia o registrador REG_FUNC_RET
		if (instr[OPCODE_WIDTH-1:0] == RET) begin
			A_addr      <= REG_FUNC_RET;
		end
		// faca pc_out = pc_in (nao mexemos no pc no pipeline 2)
		pc_out      <= pc_in;
	end
end

endmodule

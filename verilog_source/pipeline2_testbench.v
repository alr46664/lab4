module pipeline2_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// indica o numero de testes a serem feitos
parameter N_TESTES = 18;

// declaracao das input e output
reg clk_in, RST;
reg [PC_WIDTH-1:0] pc_in;
reg [INSTR_WIDTH-1:0] instr;
reg [REG_ADDR_WIDTH-1:0] reg_addr;
reg [DATA_WIDTH-1:0] reg_data;
reg reg_en;

wire signed [DATA_WIDTH-1:0] A, B, imm;
wire [REG_ADDR_WIDTH-1:0] A_addr, B_addr;
wire [PC_WIDTH-1:0] pc_out;
wire [CTRL_WIDTH-1:0] ctrl;

// instancia do modulo a ser testado
pipeline2 pipeline20(
	.clk_in(clk_in),
	.RST(RST),
	.pc_in(pc_in),
	.instr(instr),
	.reg_addr(reg_addr),
	.reg_data(reg_data),
	.reg_en(reg_en),
    .A_addr(A_addr),
    .B_addr(B_addr),
    .A(A),
    .B(B),
    .imm(imm),
    .ctrl(ctrl),
	.pc_out(pc_out)
	);


// inicializa os inputs do modulo (acima) a ser testado
task init_input;
begin    
	pc_in = PC_INITIAL;
	instr = NOP;
	reg_addr = 0;
	reg_data = 0;
	reg_en = 0;	
end
endtask

// executa o teste numero 'testes' emitindo status como resultado do teste
task execute_test;
    input integer testes;
    output reg status;

	parameter TESTE1_OPCODE = ADD,
		TESTE1_A_ADDR = 31,
		TESTE1_B_ADDR = 0,
		TESTE1_IMM = 85,
		TESTE1_PC_IN = 758,
		TESTE1_REG_ADDR = TESTE1_A_ADDR,
		TESTE1_REG_DATA = 5,
		TESTE1_REG_EN = 1;

	parameter TESTE2_OPCODE = SUB,
		TESTE2_A_ADDR = 3,
		TESTE2_B_ADDR = 17,
		TESTE2_IMM = 105,
		TESTE2_PC_IN = 1024,
		TESTE2_REG_ADDR = 0,
		TESTE2_REG_DATA = 5,
		TESTE2_REG_EN = 1;

	parameter TESTE3_OPCODE = LW,
		TESTE3_A_ADDR = 0,
		TESTE3_B_ADDR = 3,
		TESTE3_IMM = 32767,
		TESTE3_PC_IN = 8056,
		TESTE3_REG_ADDR = 2,
		TESTE3_REG_DATA = 4,
		TESTE3_REG_EN = 0;

	parameter TESTE4_OPCODE = CMP,
		TESTE4_A_ADDR = 0,
		TESTE4_B_ADDR = 3,
		TESTE4_IMM = -32768,
		TESTE4_PC_IN = 0,
		TESTE4_REG_ADDR = 3,
		TESTE4_REG_DATA = 9,
		TESTE4_REG_EN = 1;

	parameter TESTE5_OPCODE = MUL,
		TESTE5_A_ADDR = 2,
		TESTE5_B_ADDR = 3,
		TESTE5_IMM = 0,
		TESTE5_PC_IN = 64000,
		TESTE5_REG_ADDR = 2,
		TESTE5_REG_DATA = 16,
		TESTE5_REG_EN = 1;

	parameter TESTE6_OPCODE = DIV,
		TESTE6_A_ADDR = 2,
		TESTE6_B_ADDR = 0,
		TESTE6_IMM = 145,
		TESTE6_PC_IN = 65535,
		TESTE6_REG_ADDR = 2,
		TESTE6_REG_DATA = 25,
		TESTE6_REG_EN = 0;

	parameter TESTE7_OPCODE = AND,
		TESTE7_A_ADDR = 2,
		TESTE7_B_ADDR = 0,
		TESTE7_IMM = 145,
		TESTE7_PC_IN = 4040,
		TESTE7_REG_ADDR = 1,
		TESTE7_REG_DATA = 305,
		TESTE7_REG_EN = 0;

	parameter TESTE8_OPCODE = OR,
		TESTE8_A_ADDR = 3,
		TESTE8_B_ADDR = 1,
		TESTE8_IMM = 1851,
		TESTE8_PC_IN = 4654,
		TESTE8_REG_ADDR = 6,
		TESTE8_REG_DATA = 3415,
		TESTE8_REG_EN = 0;

	parameter TESTE9_OPCODE = NOT,
		TESTE9_A_ADDR = 0,
		TESTE9_B_ADDR = 6,
		TESTE9_IMM = 1601,
		TESTE9_PC_IN = 7584,
		TESTE9_REG_ADDR = 9,
		TESTE9_REG_DATA = 30115,
		TESTE9_REG_EN = 0;

	parameter TESTE10_OPCODE = CMP,
		TESTE10_A_ADDR = 5,
		TESTE10_B_ADDR = 10,
		TESTE10_IMM = 18546,
		TESTE10_PC_IN = 45012,
		TESTE10_REG_ADDR = 15,
		TESTE10_REG_DATA = 40254,
		TESTE10_REG_EN = 0;

	parameter TESTE11_OPCODE = JR,
		TESTE11_A_ADDR = 31,
		TESTE11_B_ADDR = 28,
		TESTE11_IMM = 14521,
		TESTE11_PC_IN = 32415,
		TESTE11_REG_ADDR = 17,
		TESTE11_REG_DATA = 32000,
		TESTE11_REG_EN = 0;

	parameter TESTE12_OPCODE = JPC,
		TESTE12_A_ADDR = 12,
		TESTE12_B_ADDR = 13,
		TESTE12_IMM = 24821,
		TESTE12_PC_IN = 52675,
		TESTE12_REG_ADDR = 30,
		TESTE12_REG_DATA = 45014,
		TESTE12_REG_EN = 0;

	parameter TESTE13_OPCODE = BRFL,
		TESTE13_A_ADDR = 14,
		TESTE13_B_ADDR = 22,
		TESTE13_IMM = 31052,
		TESTE13_PC_IN = 42890,
		TESTE13_REG_ADDR = 26,
		TESTE13_REG_DATA = 17084,
		TESTE13_REG_EN = 0;

	parameter TESTE14_OPCODE = CALL,
		TESTE14_A_ADDR = 23,
		TESTE14_B_ADDR = 29,
		TESTE14_IMM = 32000,
		TESTE14_PC_IN = 2090,
		TESTE14_REG_ADDR = 31,
		TESTE14_REG_DATA = 20000,
		TESTE14_REG_EN = 1;

	parameter TESTE15_OPCODE = RET,
		TESTE15_A_ADDR = 27,
		TESTE15_B_ADDR = 4,
		TESTE15_IMM = 358,
		TESTE15_PC_IN = 896,
		TESTE15_REG_ADDR = 10,
		TESTE15_REG_DATA = 2587,
		TESTE15_REG_EN = 0;

	parameter TESTE16_OPCODE = NOP,
		TESTE16_A_ADDR = 11,
		TESTE16_B_ADDR = 16,
		TESTE16_IMM = 4751,
		TESTE16_PC_IN = 6521,
		TESTE16_REG_ADDR = 17,
		TESTE16_REG_DATA = 1125,
		TESTE16_REG_EN = 0;

	parameter TESTE17_OPCODE = LW_IMM,
		TESTE17_A_ADDR = 3,
		TESTE17_B_ADDR = 0,
		TESTE17_IMM = 3000,
		TESTE17_PC_IN = 8056,
		TESTE17_REG_ADDR = 2,
		TESTE17_REG_DATA = 4,
		TESTE17_REG_EN = 0;

begin			
	case(testes)
	0: begin
		instr[OPCODE_WIDTH-1:0]                           <= TESTE1_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] <= TESTE1_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] <= TESTE1_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] <= TESTE1_IMM;
		pc_in <= TESTE1_PC_IN;
		reg_addr <= TESTE1_REG_ADDR;
		reg_data <= TESTE1_REG_DATA;
		reg_en <= TESTE1_REG_EN;
		if (ctrl == NOP && pc_out == PC_INITIAL+1) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	1: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE2_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE2_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE2_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE2_IMM;
		pc_in     <= TESTE2_PC_IN;
		reg_addr  <= TESTE2_REG_ADDR;
		reg_data  <= TESTE2_REG_DATA;
		reg_en    <= TESTE2_REG_EN;
		if (ctrl == TESTE1_OPCODE && A_addr == TESTE1_A_ADDR && B_addr == TESTE1_B_ADDR && imm == TESTE1_IMM && pc_out == TESTE1_PC_IN && A == TESTE1_REG_DATA) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	2: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE3_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE3_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE3_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE3_IMM;
		pc_in     <= TESTE3_PC_IN;
		reg_addr  <= TESTE3_REG_ADDR;
		reg_data  <= TESTE3_REG_DATA;
		reg_en    <= TESTE3_REG_EN;
		if (ctrl == TESTE2_OPCODE && A_addr == TESTE2_A_ADDR && B_addr == TESTE2_B_ADDR && imm == TESTE2_IMM && pc_out == TESTE2_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	3: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE4_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE4_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE4_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE4_IMM;
		pc_in     <= TESTE4_PC_IN;
		reg_addr  <= TESTE4_REG_ADDR;
		reg_data  <= TESTE4_REG_DATA;
		reg_en    <= TESTE4_REG_EN;
		if (ctrl == TESTE3_OPCODE && A_addr == TESTE3_A_ADDR && B_addr == TESTE3_B_ADDR && imm == TESTE3_IMM && pc_out == TESTE3_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	4: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE5_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE5_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE5_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE5_IMM;
		pc_in     <= TESTE5_PC_IN;
		reg_addr  <= TESTE5_REG_ADDR;
		reg_data  <= TESTE5_REG_DATA;
		reg_en    <= TESTE5_REG_EN;
		if (ctrl == TESTE4_OPCODE && A_addr == TESTE4_A_ADDR && B_addr == TESTE4_B_ADDR && imm == TESTE4_IMM && pc_out == TESTE4_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	5: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE6_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE6_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE6_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE6_IMM;
		pc_in     <= TESTE6_PC_IN;
		reg_addr  <= TESTE6_REG_ADDR;
		reg_data  <= TESTE6_REG_DATA;
		reg_en    <= TESTE6_REG_EN;
		if (ctrl == TESTE5_OPCODE && A_addr == TESTE5_A_ADDR && B_addr == TESTE5_B_ADDR && imm == TESTE5_IMM && pc_out == TESTE5_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	6: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE7_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE7_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE7_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE7_IMM;
		pc_in     <= TESTE7_PC_IN;
		reg_addr  <= TESTE7_REG_ADDR;
		reg_data  <= TESTE7_REG_DATA;
		reg_en    <= TESTE7_REG_EN;
		if (ctrl == TESTE6_OPCODE && A_addr == TESTE6_A_ADDR && B_addr == TESTE6_B_ADDR && imm == TESTE6_IMM && pc_out == TESTE6_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	7: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE8_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE8_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE8_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE8_IMM;
		pc_in     <= TESTE8_PC_IN;
		reg_addr  <= TESTE8_REG_ADDR;
		reg_data  <= TESTE8_REG_DATA;
		reg_en    <= TESTE8_REG_EN;
		if (ctrl == TESTE7_OPCODE && A_addr == TESTE7_A_ADDR && B_addr == TESTE7_B_ADDR && imm == TESTE7_IMM && pc_out == TESTE7_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	8: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE9_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE9_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE9_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE9_IMM;
		pc_in     <= TESTE9_PC_IN;
		reg_addr  <= TESTE9_REG_ADDR;
		reg_data  <= TESTE9_REG_DATA;
		reg_en    <= TESTE9_REG_EN;
		if (ctrl == TESTE8_OPCODE && A_addr == TESTE8_A_ADDR && B_addr == TESTE8_B_ADDR && imm == TESTE8_IMM && pc_out == TESTE8_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	9: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE10_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE10_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE10_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE10_IMM;
		pc_in     <= TESTE10_PC_IN;
		reg_addr  <= TESTE10_REG_ADDR;
		reg_data  <= TESTE10_REG_DATA;
		reg_en    <= TESTE10_REG_EN;
		if (ctrl == TESTE9_OPCODE && A_addr == TESTE9_A_ADDR && B_addr == TESTE9_B_ADDR && imm == TESTE9_IMM && pc_out == TESTE9_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	10: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE11_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE11_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE11_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE11_IMM;
		pc_in     <= TESTE11_PC_IN;
		reg_addr  <= TESTE11_REG_ADDR;
		reg_data  <= TESTE11_REG_DATA;
		reg_en    <= TESTE11_REG_EN;
		if (ctrl == TESTE10_OPCODE && A_addr == TESTE10_A_ADDR && B_addr == TESTE10_B_ADDR && imm == TESTE10_IMM && pc_out == TESTE10_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	11: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE12_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE12_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE12_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE12_IMM;
		pc_in     <= TESTE12_PC_IN;
		reg_addr  <= TESTE12_REG_ADDR;
		reg_data  <= TESTE12_REG_DATA;
		reg_en    <= TESTE12_REG_EN;
		if (ctrl == TESTE11_OPCODE && A_addr == TESTE11_A_ADDR && B_addr == TESTE11_B_ADDR && imm == TESTE11_IMM && pc_out == TESTE11_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	12: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE13_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE13_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE13_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE13_IMM;
		pc_in     <= TESTE13_PC_IN;
		reg_addr  <= TESTE13_REG_ADDR;
		reg_data  <= TESTE13_REG_DATA;
		reg_en    <= TESTE13_REG_EN;
		if (ctrl == TESTE12_OPCODE && A_addr == TESTE12_A_ADDR && B_addr == TESTE12_B_ADDR && imm == TESTE12_IMM && pc_out == TESTE12_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	13: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE14_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE14_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE14_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE14_IMM;
		pc_in     <= TESTE14_PC_IN;
		reg_addr  <= TESTE14_REG_ADDR;
		reg_data  <= TESTE14_REG_DATA;
		reg_en    <= TESTE14_REG_EN;
		if (ctrl == TESTE13_OPCODE && A_addr == TESTE13_A_ADDR && B_addr == TESTE13_B_ADDR && imm == TESTE13_IMM && pc_out == TESTE13_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	14: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE15_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE15_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE15_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE15_IMM;
		pc_in     <= TESTE15_PC_IN;
		reg_addr  <= TESTE15_REG_ADDR;
		reg_data  <= TESTE15_REG_DATA;
		reg_en    <= TESTE15_REG_EN;
		if (ctrl == TESTE14_OPCODE && A_addr == TESTE14_A_ADDR && B_addr == TESTE14_B_ADDR && imm == TESTE14_IMM && pc_out == TESTE14_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	15: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE16_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE16_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE16_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE16_IMM;
		pc_in     <= TESTE16_PC_IN;
		reg_addr  <= TESTE16_REG_ADDR;
		reg_data  <= TESTE16_REG_DATA;
		reg_en    <= TESTE16_REG_EN;
        //   status <= 0;
		if (ctrl == TESTE15_OPCODE && A_addr == TESTE15_A_ADDR && B_addr == TESTE15_B_ADDR && imm == TESTE15_IMM && pc_out == TESTE15_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
		status <= 0;		
	end
	16: begin
		instr[OPCODE_WIDTH-1:0]                                             <= TESTE17_OPCODE;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]                   <= TESTE17_A_ADDR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]  <= TESTE17_B_ADDR;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]                  <= TESTE17_IMM;
		pc_in     <= TESTE17_PC_IN;
		reg_addr  <= TESTE17_REG_ADDR;
		reg_data  <= TESTE17_REG_DATA;
		reg_en    <= TESTE17_REG_EN;
		if (ctrl == TESTE16_OPCODE && A_addr == TESTE16_A_ADDR && B_addr == TESTE16_B_ADDR && imm == TESTE16_IMM && pc_out == TESTE16_PC_IN) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	
	default: begin
		status <= 0;
	end
	endcase
end
endtask

// mostra as entradas no console
task display_input;
    input integer testes;
    input reg status;
begin    
	$display("  Teste # %2d  =>  ", testes);
    $display("\t ------ ENTRADAS -------  ");
	$display("\t PC_IN: %6d  ", pc_in);
	$display("\t REG_WRITE  -  EN: %b  -  ADDR: %3d  -  DATA: %6d  ", reg_en, reg_addr, reg_data);
	$display("\t INSTR (%2d): %b  ", INSTR_WIDTH, instr);
	$display("\t    IMM    (%2d): %b (%6d)", (INSTR_WIDTH)-(OPCODE_WIDTH+REG_ADDR_WIDTH*2), instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2], instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]);
	$display("\t    REG_2  (%2d): %b  (%2d)", (OPCODE_WIDTH+REG_ADDR_WIDTH*2)-(OPCODE_WIDTH+REG_ADDR_WIDTH), instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH], instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]);
	$display("\t    REG_1  (%2d): %b  (%2d)", (OPCODE_WIDTH+REG_ADDR_WIDTH)-(OPCODE_WIDTH), instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH], instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]);
	$write(  "\t    OPCODE (%2d): %b (", OPCODE_WIDTH, instr[OPCODE_WIDTH-1:0]);
	case(instr[OPCODE_WIDTH-1:0])
	LW:   $display("LW)");
	LW_IMM:   $display("LW_IMM)");
	SW:   $display("SW)");
	ADD:  $display("ADD)");
	SUB:  $display("SUB)");
	MUL:  $display("MUL)");
	DIV:  $display("DIV)");
	AND:  $display("AND)");
	OR:   $display("OR)");
	NOT:  $display("NOT)");
	CMP:  $display("CMP)");
	JR:   $display("JR)");
	JPC:  $display("JPC)");
	BRFL: $display("BRFL)");
	CALL: $display("CALL)");
	RET:  $display("RET)");
	NOP:  $display("NOP)");
	
	endcase
end
endtask

// mostra as saidas no console
task display_output;
    input integer testes;
    input reg status;
begin
    $display("\t ------ SAIDAS -------  ");
    $display("\t B:    %6d ", B);
	$display("\t A:    %6d", A);
	$display("\t IMM:  %6d ", imm);
	$display("\t CTRL: %b  ", ctrl);
	$display("\t PC_OUT: %6d  ", pc_out);
	$display(" ");
end
endtask

// faz o include do modelo de testbench
// ESTE INCLUDE DEVE VIR POR ULTIMO !!!
`include "testbench.v"


endmodule

module pipeline2_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// indica o numero de testes a serem feitos
parameter N_TESTES = 6;

// contador de testes a serem feitos
integer testes;

// declaracao das input e output
reg clk_in, RST;
reg [INSTR_WIDTH-1:0] instr;
reg [REG_ADDR_WIDTH-1:0] reg_addr;
reg [DATA_WIDTH-1:0] reg_data;
reg reg_en;

wire signed [DATA_WIDTH-1:0] A, B, imm;
wire [CTRL_WIDTH-1:0] ctrl;
wire clk_out;

// instancia do modulo a ser testado
pipeline2 pipeline20(
	.clk_in(clk_in),
	.RST(RST),
	.instr(instr),
	.reg_addr(reg_addr),
	.reg_data(reg_data),
	.reg_en(reg_en),
    .A(A),
    .B(B),
    .imm(imm),
    .ctrl(ctrl),
    .clk_out(clk_out));


// inicializando testes em 0
initial begin
    testes = -1;
    // inicilizacao dos inputs
    clk_in = 0;
    // faca rotina de reset
    RST = 1;
    #1;
    RST = 0;
    #1;
    RST = 1;
end

// gerando clock
always begin
	// gere o clock quando os sinais de teste estiverem estabilizados
	#4;
	clk_in = !clk_in;
end

// gerandos os testes aqui
always begin
	#8;
	testes = testes+1;
	// DESCREVA OS CASOS DE TESTE ABAIXO
	case(testes)
	0: begin
		instr[OPCODE_WIDTH-1:0] = ADD;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 31;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 0;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 85;
		reg_addr = 8;
		reg_data = 5;
		reg_en = 0;
	end
	1: begin
		instr[OPCODE_WIDTH-1:0] = SUB;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 3;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 17;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 105;
		reg_addr = 0;
		reg_data = 5;
		reg_en = 1;
	end
	2: begin
		instr[OPCODE_WIDTH-1:0] = LW;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 0;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 3;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 32767;
		reg_addr = 2;
		reg_data = 4;
		reg_en = 0;
	end
	3: begin
		instr[OPCODE_WIDTH-1:0] = CMP;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 0;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 3;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = -32768;
		reg_addr = 3;
		reg_data = 9;
		reg_en = 1;
	end
	4: begin
		instr[OPCODE_WIDTH-1:0] = MUL;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 2;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 3;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 0;
		reg_addr = 2;
		reg_data = 16;
		reg_en = 1;
	end
	5: begin
		instr[OPCODE_WIDTH-1:0] = DIV;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 2;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 0;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 145;
		reg_addr = 2;
		reg_data = 25;
		reg_en = 0;
	end
	default: begin
		// nao faca nada de proposito
	end
	endcase
end

// mostre os resultados dos testes
always @(posedge clk_in) begin
    // aqui aparecem os resultados dos testes
	if (testes >= 0 && testes  <= N_TESTES) begin
		if (testes > 0) begin
			// SAIDAS (estaveis)
			$display("\t B:    %6d ", B);
			$display("\t A:    %6d", A);
		    $display("\t IMM:  %6d ", imm);
		    $display("\t CTRL: %b  ", ctrl);
		    $display(" ");
		end
		if (testes < N_TESTES) begin
			// ENTRADAS (estaveis)
			$display("  Teste # %2d  =>  ", testes);
			$display("\t REG_WRITE  -  EN: %b  -  ADDR: %3d  -  DATA: %6d  ", reg_en, reg_addr, reg_data);
		    $display("\t INSTR (%2d): %b  ", INSTR_WIDTH, instr);
		    $display("\t    IMM    (%2d): %b (%6d)", (INSTR_WIDTH)-(OPCODE_WIDTH+REG_ADDR_WIDTH*2), instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2], instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2]);
		    $display("\t    REG_2  (%2d): %b  (%2d)", (OPCODE_WIDTH+REG_ADDR_WIDTH*2)-(OPCODE_WIDTH+REG_ADDR_WIDTH), instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH], instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH]);
		    $display("\t    REG_1  (%2d): %b  (%2d)", (OPCODE_WIDTH+REG_ADDR_WIDTH)-(OPCODE_WIDTH), instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH], instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH]);
		    $write(  "\t    OPCODE (%2d): %b (", OPCODE_WIDTH, instr[OPCODE_WIDTH-1:0]);
		    case(instr[OPCODE_WIDTH-1:0])
			LW:   $display("LW)");
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
	end
end


endmodule
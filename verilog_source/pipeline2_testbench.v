module pipeline2_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// indica o numero de testes a serem feitos
parameter N_TESTES = 16;

// contador de testes a serem feitos
integer testes;

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
wire done;

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
	.pc_out(pc_out),
    .done(done));


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
always @(negedge clk_in) begin
	// gere casos de teste
	testes = testes+1;
	// DESCREVA OS CASOS DE TESTE ABAIXO
	case(testes)
	0: begin
		instr[OPCODE_WIDTH-1:0] = ADD;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 31;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 0;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 85;
		pc_in = 758;
		reg_addr = 8;
		reg_data = 5;
		reg_en = 0;
	end
	1: begin
		instr[OPCODE_WIDTH-1:0] = SUB;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 3;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 17;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 105;
		pc_in = 1024;
		reg_addr = 0;
		reg_data = 5;
		reg_en = 1;
	end
	2: begin
		instr[OPCODE_WIDTH-1:0] = LW;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 0;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 3;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 32767;
		pc_in = 8056;
		reg_addr = 2;
		reg_data = 4;
		reg_en = 0;
	end
	3: begin
		instr[OPCODE_WIDTH-1:0] = CMP;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 0;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 3;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = -32768;
		pc_in = 0;
		reg_addr = 3;
		reg_data = 9;
		reg_en = 1;
	end
	4: begin
		instr[OPCODE_WIDTH-1:0] = MUL;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 2;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 3;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 0;
		pc_in = 64000;
		reg_addr = 2;
		reg_data = 16;
		reg_en = 1;
	end
	5: begin
		instr[OPCODE_WIDTH-1:0] = DIV;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 2;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 0;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 145;
		pc_in = 65535;
		reg_addr = 2;
		reg_data = 25;
		reg_en = 0;
	end
	6: begin
		instr[OPCODE_WIDTH-1:0] = AND;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 2;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 0;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 145;
		pc_in = 4040;
		reg_addr = 1;
		reg_data = 305;
		reg_en = 0;
	end
	7: begin
		instr[OPCODE_WIDTH-1:0] = OR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 3;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 1;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 1851;
		pc_in = 4654;
		reg_addr = 6;
		reg_data = 3415;
		reg_en = 0;
	end
	8: begin
		instr[OPCODE_WIDTH-1:0] = NOT;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 0;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 6;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 1601;
		pc_in = 7584;
		reg_addr = 9;
		reg_data = 30115;
		reg_en = 0;
	end
	9: begin
		instr[OPCODE_WIDTH-1:0] = CMP;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 5;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 10;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 18546;
		pc_in = 45012;
		reg_addr = 15;
		reg_data = 40254;
		reg_en = 0;
	end
	10: begin
		instr[OPCODE_WIDTH-1:0] = JR;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 31;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 28;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 14521;
		pc_in = 32415;
		reg_addr = 17;
		reg_data = 35454;
		reg_en = 0;
	end
	11: begin
		instr[OPCODE_WIDTH-1:0] = JPC;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 12;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 13;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 24821;
		pc_in = 52675;
		reg_addr = 30;
		reg_data = 45014;
		reg_en = 0;
	end
	12: begin
		instr[OPCODE_WIDTH-1:0] = BRFL;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 14;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 22;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 31052;
		pc_in = 42890;
		reg_addr = 26;
		reg_data = 17084;
		reg_en = 0;
	end
	13: begin
		instr[OPCODE_WIDTH-1:0] = CALL;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 23;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 29;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 37824;
		pc_in = 2090;
		reg_addr = 31;
		reg_data = 20000;
		reg_en = 1;
	end
	14: begin
		instr[OPCODE_WIDTH-1:0] = RET;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 27;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 4;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 358;
		pc_in = 896;
		reg_addr = 10;
		reg_data = 25870;
		reg_en = 0;
	end
	15: begin
		instr[OPCODE_WIDTH-1:0] = NOP;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 11;
		instr[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 16;
		instr[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 4751;
		pc_in = 6521;
		reg_addr = 17;
		reg_data = 11251;
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
			$display("\t PC_OUT: %6d  ", pc_out);
		    $display(" ");
		end
		if (testes < N_TESTES) begin
			// ENTRADAS (estaveis)
			$display("  Teste # %2d  =>  ", testes);
			$display("\t PC_IN: %6d  ", pc_in);
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
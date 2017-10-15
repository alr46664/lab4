module pipeline1_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// indica o numero de testes a serem feitos
parameter N_TESTES = 11;

// contador de testes a serem feitos
integer testes;

// declaracao input / output
reg clk_in, RST;
reg [PC_WIDTH-1:0] pc_in;

wire [INSTR_WIDTH-1:0] instr;
reg [INSTR_WIDTH-1:0] instrmem;
wire [PC_WIDTH-1:0] pc_out;
wire done;
wire we;



// criacao das instancias

assign we = 1;
mem_program mem_inst(.clk(clk_in), .we(we), .addr(pc_in), .data_in(instrmem), .data_out(instr));

pipeline1 pipeline10(
	.clk_in(clk_in),
	.RST(RST),
	.pc_in(pc_in),
	.instr(instr),	
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
		pc_in = 0;
		instrmem[OPCODE_WIDTH-1:0] = ADD;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 31;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 0;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 85;	
	end
	1: begin				
		pc_in = pc_in +4;
		instrmem[OPCODE_WIDTH-1:0] = SUB;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 3;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 17;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 105;		
	end
	2: begin		
		pc_in = pc_in +4;	
		instrmem[OPCODE_WIDTH-1:0] = LW;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 0;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 3;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 32767;	
	end
	3: begin		
		pc_in = pc_in +4;
		instrmem[OPCODE_WIDTH-1:0] = CMP;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 0;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 3;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = -32767;	
	end
	4: begin		
		pc_in = pc_in +4;
		instrmem[OPCODE_WIDTH-1:0] = MUL;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 2;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 3;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 0;
	end
	5: begin		
		pc_in = pc_in +4;	
		instrmem[OPCODE_WIDTH-1:0] = DIV;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 2;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 0;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 145;
	end
	6: begin		
		pc_in = pc_in +4;
		instrmem[OPCODE_WIDTH-1:0] = AND;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 2;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 0;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 145;	
	end
	7: begin		
		pc_in = pc_in +4;
		instrmem[OPCODE_WIDTH-1:0] = OR;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 3;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 1;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 1851;
	end
	8: begin		
		pc_in = pc_in +4;
		instrmem[OPCODE_WIDTH-1:0] = NOT;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 0;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 6;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 1601;	
	end
	9: begin		
		pc_in = pc_in +4;
		instrmem[OPCODE_WIDTH-1:0] = CMP;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 5;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 10;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 18546;	
	end
	10: begin		
		pc_in = pc_in +4;
		instrmem[OPCODE_WIDTH-1:0] = JR;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 31;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 28;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 14521;	
	end
	11: begin		
		pc_in = pc_in +4;
		instrmem[OPCODE_WIDTH-1:0] = JPC;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 12;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 13;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 24821;		
	end
	12: begin		
		pc_in = pc_in +4;
		instrmem[OPCODE_WIDTH-1:0] = BRFL;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 27;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 4;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 358;	
	end
	13: begin
		pc_in = pc_in +4;
		instrmem[OPCODE_WIDTH-1:0] = CALL;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 23;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 29;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 37824;
			
	end
	14: begin
		pc_in = pc_in +4;	
		instrmem[OPCODE_WIDTH-1:0] = RET;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 27;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 4;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 358;	
	end
	15: begin		
		pc_in = pc_in +4;	
		instrmem[OPCODE_WIDTH-1:0] = NOP;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH-1:OPCODE_WIDTH] = 11;
		instrmem[OPCODE_WIDTH+REG_ADDR_WIDTH*2-1:OPCODE_WIDTH+REG_ADDR_WIDTH] = 16;
		instrmem[INSTR_WIDTH-1:OPCODE_WIDTH+REG_ADDR_WIDTH*2] = 4751;
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
			$display("\t INSTR (%2d): %b  ", INSTR_WIDTH, instr);
			$display("\t PC_OUT: %6d  ", pc_out);
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
			$display(" ");	
		end
		if (testes < N_TESTES) begin
			// ENTRADAS (estaveis)
			$display("  Teste # %2d  =>  ", testes);
			$display("\t PC_IN: %6d  ", pc_in);		    
		    
	    end
	end
end


endmodule
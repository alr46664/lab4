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



// criacao das instancias
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
	end
	1: begin				
		pc_in = pc_in +4;		
	end
	2: begin		
		pc_in = pc_in +4;		
	end
	3: begin		
		pc_in = pc_in +4;		
	end
	4: begin		
		pc_in = pc_in +4;		
	end
	5: begin		
		pc_in = pc_in +4;			
	end
	6: begin		
		pc_in = pc_in +4;		
	end
	7: begin		
		pc_in = pc_in +4;		
	end
	8: begin		
		pc_in = pc_in +4;		
	end
	9: begin		
		pc_in = pc_in +4;		
	end
	10: begin		
		pc_in = pc_in +4;		
	end
	11: begin		
		pc_in = pc_in +4;			
	end
	12: begin		
		pc_in = pc_in +4;		
	end
	13: begin
		pc_in = pc_in +4;		
			
	end
	14: begin
		pc_in = pc_in +4;			
	end
	15: begin		
		pc_in = pc_in +4;		
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

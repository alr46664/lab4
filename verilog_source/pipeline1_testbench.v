module pipeline1_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// numero de testes a serem feitos
parameter N_TESTES = 8;

// contador de testes a serem feitos
integer testes;

// declaracao input / output
reg clk_in, RST, pc_chg;
reg [PC_WIDTH-1:0] pc_in;

wire [INSTR_WIDTH-1:0] instr;
wire [PC_WIDTH-1:0] pc_out;



// criacao das instancias
pipeline1 pipeline10(
	.clk_in(clk_in),
	.RST(RST),
	.pc_chg(pc_chg),
	.pc_in(pc_in),
	.instr(instr),
	.pc_out(pc_out)
	);

// inicializando testes em 0
initial begin
    testes = -1;
    // inicilizacao dos inputs
    clk_in = 0;
    // faca rotina de reset
    RST = 1;
    #3;
    RST = 0;
    #3;
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
	testes <= testes+1;
	// DESCREVA OS CASOS DE TESTE ABAIXO
	case(testes)
	0: begin
	    pc_chg <= 0;
	    pc_in  <= 5;
	end
	1: begin
	    pc_chg <= 0;
	    pc_in  <= 15;
	end
	2: begin
	    pc_chg <= 1;
	    pc_in  <= 20;
	end
	3: begin
		pc_chg <= 1;
		pc_in  <= 1;
	end
	4: begin
		pc_chg <= 0;
		pc_in  <= 5;
	end
	5: begin
		pc_chg <= 0;
		pc_in  <= 5;
	end
	6: begin
		pc_chg <= 0;
		pc_in  <= 5;
	end
	7: begin
		pc_chg <= 0;
		pc_in  <= 5;
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
			$display("\t INSTR (%3d): %b  ", INSTR_WIDTH, instr);
			$display("\t PC_OUT: %6d  ", pc_out);
			$display(" ");
		end
		if (testes < N_TESTES) begin
			// ENTRADAS (estaveis)
			$display("  Teste # %2d  =>  ", testes);
			$display("\t PC_CHG: %b  ",  pc_chg);
			$display("\t PC_IN:  %6d  ", pc_in);

	    end
	end
end


endmodule

module mem_program_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// indica o numero de testes a serem feitos
parameter N_TESTES = 6;

// contador de testes a serem feitos
integer testes;

// declaracao de input / output
reg clk, we;
reg [MEM_WIDTH-1:0] addr;
reg [INSTR_WIDTH-1:0] data_in;
wire [INSTR_WIDTH-1:0] data_out;

//cria a instancia de memoria ROM (nao gravavel)
mem_program mem_inst (
	.clk(clk), .we(we), .addr(addr),
	.data_in(data_in), .data_out(data_out));

// inicializando inputs
initial begin
	testes = -1;
	// inicilizacao dos inputs
	clk  = 0;
	// pra addr = PC_INITIAL, precisamos colocar o -1
	addr    = PC_INITIAL - 1;
	we      = 0;
	data_in = 0;
end

// gerando clock
always begin
	// gere o clock quando os sinais de teste estiverem estabilizados
	#4;
	clk = !clk;
end

// gerandos os testes aqui
always @(negedge clk) begin
	// gere casos de teste
	testes = testes+1;
	// DESCREVA OS CASOS DE TESTE ABAIXO
	case(testes)
	0: begin
		we = 1;
		addr = addr + 1;
		data_in = 32'h0050;
	end
	1: begin
		we = 1;
		addr = addr + 1;
		data_in = 32'h0850;
	end
	2: begin
		we = 1;
		addr = addr + 1;
		data_in = 32'h8152;
	end
	3: begin
		we = 0;
		addr = PC_INITIAL;
		data_in = 32'h1550;
	end
	4: begin
		we = 0;
		addr = addr+1;
		data_in = 32'h2875;
	end
	5: begin
		we = 0;
		addr = addr+1;
		data_in = 32'h1647;
	end

	default: begin
		// nao faca nada de proposito
	end
	endcase
end

// mostre os resultados dos testes
always @(posedge clk) begin
    // aqui aparecem os resultados dos testes
	if (testes >= 0 && testes  <= N_TESTES) begin
		if (testes > 0) begin
			// SAIDAS (estaveis)
			$display("\t ------- SAIDAS -------  ");
		    $display("\t DATA_OUT (%3d): %h  ", INSTR_WIDTH, data_out);
		    $display(" ");
		end
		if (testes < N_TESTES) begin
			// ENTRADAS (estaveis)
			$display("  Teste # %2d  =>  ", testes);
			$display("\t ------- ENTRADAS -------  ");
			$display("\t WE: %6d  ", we);
			$display("\t ADDR: %6d ", addr);
		    $display("\t DATA_IN (%3d): %h  ", INSTR_WIDTH, data_in);
		    $display(" ");
	    end
	end
end

endmodule
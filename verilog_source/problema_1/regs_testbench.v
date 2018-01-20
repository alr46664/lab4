module regs_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// indica o numero de testes a serem feitos
parameter N_TESTES = 11;

// contador de testes a serem feitos
integer testes;

// declaracao input / output
reg clk, en_write;
reg [REG_ADDR_WIDTH-1:0] addr_write, addr_read1, addr_read2;
reg signed [DATA_WIDTH-1:0] data_write;

wire signed [DATA_WIDTH-1:0] data_read1, data_read2;

// criacao das instancias
regs regs0(
	.clk(clk),
	.en_write(en_write),
	.data_write(data_write),
	.addr_write(addr_write),
	.addr_read1(addr_read1),
	.addr_read2(addr_read2),
	.data_read1(data_read1),
	.data_read2(data_read2));

// inicializando testes em 0
initial begin
    testes <= 0;
    // inicilizacao dos inputs
    clk <= 0;
end

// gerando clock
always begin
	// gere o clock quando os sinais de teste estiverem estabilizados
	#2;
	clk = !clk;
end

// gerandos os testes aqui
always begin
	#4;
	testes = testes+1;
	// DESCREVA OS CASOS DE TESTE ABAIXO
	case(testes)
	1: begin
		en_write = 1;
		addr_write = 0;
		data_write = 5;
		addr_read1 = 0;
		addr_read2 = 0;
	end
	2: begin
		en_write = 0;
		addr_write = 7;
		data_write = 65;
		addr_read1 = 0;
		addr_read2 = 1;
	end
	3: begin
		en_write = 1;
		addr_write = 8;
		data_write = 11;
		addr_read1 = 0;
		addr_read2 = 1;
	end
	4: begin
		en_write = 0;
		addr_write = 7;
		data_write = 18;
		addr_read1 = 8;
		addr_read2 = 1;
	end
	5: begin
		en_write = 1;
		addr_write = 1;
		data_write = 16;
		addr_read1 = 0;
		addr_read2 = 1;
	end
	6: begin
		en_write = 1;
		addr_write = 2;
		data_write = 24;
		addr_read1 = 0;
		addr_read2 = 1;
	end
	7: begin
		en_write = 0;
		addr_write = 2;
		data_write = 29;
		addr_read1 = 1;
		addr_read2 = 2;
	end
	8: begin
		en_write = 1;
		addr_write = 15;
		data_write = 20;
		addr_read1 = 1;
		addr_read2 = 2;
	end
	9: begin
		en_write = 0;
		addr_write = 21;
		data_write = 25400;
		addr_read1 = 15;
		addr_read2 = 0;
	end
	10: begin
		en_write = 1;
		addr_write = 31;
		data_write = 2000;
		addr_read1 = 15;
		addr_read2 = 0;
	end
	11: begin
		en_write = 0;
		addr_write = 20;
		data_write = 200;
		addr_read1 = 31;
		addr_read2 = 0;
	end
	default: begin
		// nao faca nada de proposito
	end
	endcase
end

// mostre os resultados dos testes
always @(posedge clk) begin
	if (testes > 0 && testes  <= N_TESTES) begin
	    // aqui aparecem os resultados das entradas
		$display("  Teste # %2d  =>  ", testes);
		$display("\t WRITE  -  EN: %b  -  ADDR: %3d  -  DATA: %6d  ", en_write, addr_write, data_write);
	    $display("\t READ_1\n\t   ADDR: %3d  ", addr_read1);
	    $display("\t   DATA: %6d  ", data_read1);
	    $display("\t READ_2\n\t   ADDR: %3d  ", addr_read2);
	    $display("\t   DATA: %6d  ", data_read2);
	    $display(" ");
	end
end


endmodule
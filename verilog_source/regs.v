module regs(
	clk,         // clock
	en_write,    // enable do write de data_write em addr_write
	addr_write,  // addr do reg a ser gravado
	data_write,  // dados a serem gravados no registrador addr_write
	addr_read1,  // addr do registrador 1 a ser lido
	addr_read2,  // addr do registrador 2 a ser lido
	data_read1,  // dados do registrador 1 lido
	data_read2  // dados do registrador 1 lido
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada / saida
input clk, en_write;
input [REG_ADDR_WIDTH-1:0] addr_write, addr_read1, addr_read2;
input [DATA_WIDTH-1:0] data_write;

output reg [DATA_WIDTH-1:0] data_read1, data_read2;

// banco de registradores
reg [DATA_WIDTH-1:0] registers [0:REG_ADDR_WIDTH-1];

always @(posedge clk) begin
	// verifique se precisamos fazer uma gravacao
	if (en_write) begin
		registers[addr_write] <= data_write;
		// temos de tratar a leitura para evitar corrupcao de dados
		data_read1 <= (addr_write == addr_read1 ? data_write : registers[addr_read1]);
		data_read2 <= (addr_write == addr_read2 ? data_write : registers[addr_read2]);
	end else begin
		// nenhum controle especial precisa ser feito, somente a leitura
		data_read1 <= registers[addr_read1];
		data_read2 <= registers[addr_read2];
	end
end

endmodule
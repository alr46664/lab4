// memoria dual port - single clk que permite escrita e leitura
// simultaneas em portas distintas
module regs(
	clk,       // clk
	en_write,      // write enable
	data_write,    // dados in
	addr_write,    // endereco
	addr_read1,    // endereco
	addr_read2,    // endereco
	data_read1,     // saida
	data_read2
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada / saida
input clk, en_write;
input signed [DATA_WIDTH-1:0] data_write;
input [REG_ADDR_WIDTH-1:0] addr_write, addr_read1, addr_read2;

output [DATA_WIDTH-1:0] data_read1, data_read2;

// declaracao da memoria RAM
reg [DATA_WIDTH-1:0] ram [0:(1<<REG_ADDR_WIDTH)-1];

// Port A - write only
always @ (posedge clk) begin
	if (en_write) begin
		ram[addr_write] <= data_write;
	end
end

// data read
assign data_read1 = (addr_write == addr_read1 && en_write ? data_write : ram[addr_read1]);
assign data_read2 = (addr_write == addr_read2 && en_write ? data_write : ram[addr_read2]);

// inicialize os registradores 0 e 1
initial begin
	ram[0] <= 0;
	ram[1] <= 1;
end


endmodule
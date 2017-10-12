// memoria dual port - single clk que permite escrita e leitura
// simultaneas em portas distintas
module mem_dport_sclk(
	clk,       // clk
	we_a,      // write enable - porta A
	we_b,      // write enable - porta B
	data_a,    // dados in - porta A
	data_b,    // dados in - porta B
	addr_a,    // endereco - porta A
	addr_b,    // endereco - porta B
	out_a,     // saida - porta A
	out_b      // saida - porta B
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada / saida
input clk, we_a, we_b;
input signed [DATA_WIDTH-1:0] data_a, data_b;
input [MEM_WIDTH-1:0] addr_a, addr_b;

output reg [DATA_WIDTH-1:0] out_a, out_b;

// declaracao da memoria RAM
reg [DATA_WIDTH-1:0] ram [0:MEM_WIDTH-1];

// Port A
always @ (posedge clk) begin
	if (we_a) begin
		ram[addr_a] <= data_a;
		out_a <= data_a;
	end else begin
		out_a <= ram[addr_a];
	end
end

// Port B
always @ (posedge clk) begin
	if (we_b) begin
		ram[addr_b] <= data_b;
		out_b <= data_b;
	end else begin
		out_b <= ram[addr_b];
	end
end

endmodule
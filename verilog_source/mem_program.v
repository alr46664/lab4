module mem_program(
	clk,       // clock_in
	we,         // write enable
	addr,      // endereco da memoria
	data_in,   // dados a serem gravados
	data_out    // dados a serem lidos
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada / saida
input clk, we;
input [MEM_WIDTH-1:0] addr;
input [INSTR_WIDTH-1:0] data_in;

output reg [INSTR_WIDTH-1:0] data_out;

// declaracao da memoria
reg [DATA_WIDTH-1:0] mem [0:(1<<MEM_WIDTH)-1];

always @(posedge clk) begin
	if (we) begin
		mem[addr] <= data_in;
		// default - mande na saida o que for recebido na entrada
		data_out  <= data_in;
	end else begin
		data_out <= mem[addr];
	end
end

endmodule
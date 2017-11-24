module mem_program(
	clk,       // clock_in
    we,        // write enable
	addr,      // endereco da memoria
    data_in,   // dados a serem gravados
	data_out   // dados a serem lidos
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada / saida
input clk, we;
input [INSTR_WIDTH-1:0] data_in;
input [PC_WIDTH-1:0] addr;

output reg [INSTR_WIDTH-1:0] data_out;

// declaracao da memoria
reg [INSTR_WIDTH-1:0] ram [0:(1<<PC_WIDTH)-1];

// saida da memoria ROM de programa
always @(posedge clk) begin
	if (we) begin
        ram[addr] <= data_in;
        // default - mande na saida o que for recebido na entrada
        data_out  <= data_in;
    end else begin
        data_out <= ram[addr];
    end
end

// isto sintetiza, mas demora (tenha paciencia!)
initial begin
	$readmemb("../assembler/program.bin", ram);
end

endmodule
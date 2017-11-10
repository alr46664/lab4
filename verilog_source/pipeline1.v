module pipeline1(
    clk_in,    // clock_in
    RST,       // reset
    pc_chg,    // indica mudanca do PC fora do pipeline 1
    pc_in,     // entrada - contador de programa
    instr,     // instrucao
    pc_out    // saida - contador de programa
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada

input clk_in, RST, pc_chg;
input [PC_WIDTH-1:0] pc_in;

// declaracao de saida

output [INSTR_WIDTH-1:0] instr;
output reg [PC_WIDTH-1:0] pc_out;

// variaveis auxiliares
reg [PC_WIDTH-1:0] new_pc;
wire we;
wire [INSTR_WIDTH-1:0] data;

// instancia de Memoria ROM de programa
mem_program rom0(.clk(clk_in), .we(we), .addr(new_pc), .data_in(data), .data_out(instr));

assign we   = 0;
assign data = 0;

// defina o PC de leitura de memoria
always @(posedge clk_in) begin
    if (!RST) begin
        new_pc <= PC_INITIAL;
    end else if (pc_chg) begin
        new_pc <= pc_in;
    end else begin
        new_pc <= new_pc + 1;
    end
end

// defina saida do PC + 1
always @(posedge clk_in) begin
    if (!RST) begin
        pc_out <= PC_INITIAL + 1;
    end else begin
        pc_out <= new_pc + 1;
    end
end

endmodule

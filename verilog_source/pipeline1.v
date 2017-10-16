module pipeline1(
    clk_in,    // clock_in
    RST,       // reset
    pc_chg,    // indica mudanca do PC fora do pipeline 1
    pc_in,     // entrada - contador de programa
    instr,     // instrucao
    pc_out,    // saida - contador de programa
    done       // saidas estaveis
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada

input clk_in, RST, pc_chg;
input [PC_WIDTH-1:0] pc_in;

// declaracao de saida

output [INSTR_WIDTH-1:0] instr;
output reg [PC_WIDTH-1:0] pc_out;
output reg done;

// variaveis auxiliares
reg [PC_WIDTH-1:0] new_pc;
wire we;
wire [INSTR_WIDTH-1:0] data;

// instancia de Memoria ROM de programa
mem_program rom0(.clk(clk_in), .we(we), .addr(new_pc), .data_in(data), .data_out(instr));

assign we   = 0;
assign data = 0;

// defina o novo PC
always @(posedge clk_in or negedge RST or pc_chg or pc_in) begin
    if (!RST) begin
        new_pc <= PC_INITIAL;
    end else if (pc_chg) begin
        new_pc <= pc_in;
    end else begin
        new_pc <= new_pc + 1;
    end
end

// coloque as saidas disponiveis pro proximo pipeline
always @(posedge clk_in or negedge RST) begin
    if (!RST) begin
        pc_out <= PC_INITIAL + 1;   // reset - PC vai pro valor inicial
        done   <= 0;                // saidas instaveis
    end else begin
        // calcula endereço da próxima instrução (pc_chg == 1 indica
        // mudanca no PC vinda do pipeline 3)
        pc_out <= new_pc + 1;
        done   <= 1;            // saidas estaveis (== 1)
    end
end

endmodule
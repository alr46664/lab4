module pipeline1(
    clk_in,           // clock_in
    RST,              // reset
    pc_chg,           // indica mudanca do PC fora do pipeline 1
    pc_in,            // entrada - contador de programa
    interruption_has, // indica que existe interrupcao a ser processada
    interruption_instr, // instrucao da interrupcao que o pipeline 1 deve injetar (no pipeline)
    instr,            // instrucao
    pc_out            // saida - contador de programa
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada

input clk_in, RST, pc_chg, interruption_has;
input [PC_WIDTH-1:0] pc_in;
input [INSTR_WIDTH-1:0] interruption_instr;

// declaracao de saida

output [PC_WIDTH-1:0] pc_out;
output reg [INSTR_WIDTH-1:0] instr;

// variaveis auxiliares
reg [PC_WIDTH-1:0] new_pc;
wire we;
wire [INSTR_WIDTH-1:0] data;
wire [INSTR_WIDTH-1:0] instr_mem;

// instancias

// Memoria ROM de programa
mem_program rom0(.clk(clk_in), .we(we), .addr(new_pc), .data_in(data), .data_out(instr_mem));

assign we   = 0;
assign data = 0;

// saida de PC_OUT = pc_real + 1
assign pc_out = new_pc + 1;

// defina o PC de leitura de memoria
always @(posedge clk_in) begin
    if (!RST) begin
        new_pc <= PC_INITIAL;
    end else if (pc_chg) begin
        new_pc <= pc_in;
    end else if (interruption_has) begin
        // paralise o PC enquanto processamos interrupcoes
        new_pc <= new_pc;
    end else begin
        new_pc <= new_pc + 1;
    end
end

// define a saida instr
always @(*) begin
    if (interruption_has) begin
        // passe a instrucao da interrupcao
        instr <= interruption_instr;
    end else begin
        // opercao normal do pipe 1 (fetch de dados da memoria)
        instr <= instr_mem;
    end
end

endmodule

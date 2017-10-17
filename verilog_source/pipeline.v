module pipeline(
    clk,
    RST
    );

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// input output
input clk, RST;

    // pipe 1
wire pc_chg_p1;
wire [PC_WIDTH-1:0] pc_in_p1, pc_out_p1;
wire [INSTR_WIDTH-1:0] instr;

    // pipe 2
wire [REG_ADDR_WIDTH-1:0] reg_addr_p2;
wire [DATA_WIDTH-1:0] reg_data_p2;
wire reg_en_p2;
wire [REG_ADDR_WIDTH-1:0] A_addr, B_addr;
wire [DATA_WIDTH-1:0] A, B, imm;
wire [PC_WIDTH-1:0] pc_out_p2;
wire [CTRL_WIDTH-1:0] ctrl_p2;

    // pipe 3
wire [DATA_WIDTH-1:0] data_p3;
wire [MEM_WIDTH-1:0] addr_p3;
wire [REG_ADDR_WIDTH-1:0] reg_addr_p3;
wire [CTRL_WIDTH-1:0] ctrl_out_p3;

    // pipe 4
wire [DATA_WIDTH-1:0] reg_data_out_p4;
wire [REG_ADDR_WIDTH-1:0] reg_addr_out_p4;
wire [CTRL_WIDTH-1:0] ctrl_out_p4;

    // comum aos pipes
wire clk_p1, clk_p2, clk_p3, clk_p4, clk_p5;
wire done_p1, done_p2, done_p3, done_p4, done_p5;
wire eof;

// variaveis auxiliares

// instancias
pipeline_ctrl pipe_ctrl(
    .clk(clk), .RST(RST),
    .A_addr(A_addr), .B_addr(B_addr), .ctrl(ctrl_p2),         // isto ira indicar a instrucao a ser executada
    .done_p1(done_p1), .done_p2(done_p2),                     // indica que o estagio terminou de executar
    .done_p3(done_p3), .done_p4(done_p4), .done_p5(done_p5),
    .clk_p1(clk_p1), .clk_p2(clk_p2), .clk_p3(clk_p3),        // controle dos clks dos estagios de pipeline
    .clk_p4(clk_p4), .clk_p5(clk_p5),
    .eof(eof)                                                 // indica fim do programa
    );

pipeline1 pipe1(.clk_in(clk_p1), .RST(RST),
    .pc_chg(pc_chg_p1), .pc_in(pc_in_p1), .pc_out(pc_out_p1),
    .instr(instr), .done(done_p1)
    );

pipeline2 pipe2(
    .clk_in(clk_p2), .RST(RST),
    .pc_in(pc_out_p1),
    .instr(instr),
    .reg_addr(reg_addr_p2), .reg_data(reg_data_p2), .reg_en(reg_en_p2),
    .A_addr(A_addr), .B_addr(B_addr),
    .A(A), .B(B), .imm(imm),
    .pc_out(pc_out_p2),
    .ctrl(ctrl_p2),
    .done(done_p2)
    );

pipeline3 pipe3(
    .clk_in(clk_p3), .RST(RST),
    .ctrl_in(ctrl_p2), .pc_in(pc_out_p2),
    .A_addr(A_addr), .B_addr(B_addr),
    .A(A), .B(B), .imm(imm),
    .pc_chg(pc_chg_p1), .pc_out(pc_in_p1),
    .data(data_p3), .addr(addr_p3),
    .reg_addr(reg_addr_p3), .ctrl_out(ctrl_out_p3),
    .done(done_p3)
);

pipeline4 pipe4(
    .clk_in(clk_p4), .RST(RST),
    .ctrl_in(ctrl_out_p3),
    .data(data_p3), .addr(addr_p3),
    .reg_addr_in(reg_addr_p3),
    .reg_data_out(reg_data_out_p4), .reg_addr_out(reg_addr_out_p4),
    .ctrl_out(ctrl_out_p4),
    .done(done_p4)
);

pipeline5 pipe5(
    .clk_in(clk_p5), .RST(RST),
    .ctrl_in(ctrl_out_p4),
    .data(reg_data_out_p4), .addr(reg_addr_out_p4),
    .data_out(reg_data_p2), .addr_out(reg_addr_p2), .en_out(reg_en_p2),
    .done(done_p5)
);

endmodule
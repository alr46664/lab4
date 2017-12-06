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
wire mem_we_p3;
wire [DATA_WIDTH-1:0] data_p3;
wire [MEM_WIDTH-1:0] addr_p3;
wire [REG_ADDR_WIDTH-1:0] reg_addr_p3;
wire [CTRL_WIDTH-1:0] ctrl_out_p3;

    // pipe 4
wire [DATA_WIDTH-1:0] reg_data_out_p4;
wire [REG_ADDR_WIDTH-1:0] reg_addr_out_p4;
wire [CTRL_WIDTH-1:0] ctrl_out_p4;

    // multiplexador de hazard
wire [DATA_WIDTH-1:0] muxA_data, muxB_data;

// variaveis auxiliares

// instancias
pipeline_ctrl pipe_ctrl(
    .clk(clk), .RST(RST),
    .A_addr(A_addr), .B_addr(B_addr), .ctrl(ctrl_p2),         // isto ira indicar a instrucao a ser executada
    .ctrl_p34(ctrl_out_p3), .ctrl_p45(ctrl_out_p4), .reg_en_p52(reg_en_p2),
	.reg_addr_p34(reg_addr_p3),                                // controle de hazards - ADDR
    .reg_addr_p45(reg_addr_out_p4),
    .reg_addr_p52(reg_addr_p2),
    .reg_dataA_p2(A), .reg_dataB_p2(B),                       // controle de hazards - DATA - dados em output de p2
    .reg_data_p34(data_p3),                                      // dados entre p3-4
    .reg_data_p45(reg_data_out_p4),                              // dados entre p4-5
    .reg_data_p52(reg_data_p2),                                  // dados entre p5-2
    .muxA_data(muxA_data), .muxB_data(muxB_data)            // saida dos multiplexadores de hazard
    );

pipeline1 pipe1(.clk_in(clk), .RST(RST),
    .pc_chg(pc_chg_p1), .pc_in(pc_in_p1), .pc_out(pc_out_p1),
    .instr(instr)
    );

pipeline2 pipe2(
    .clk_in(clk), .RST(RST),
    .pc_in(pc_out_p1),
    .instr(instr),
    .reg_addr(reg_addr_p2), .reg_data(reg_data_p2), .reg_en(reg_en_p2),
    .A_addr(A_addr), .B_addr(B_addr),
    .A(A), .B(B), .imm(imm),
    .pc_out(pc_out_p2),
    .ctrl(ctrl_p2)
    );

pipeline3 pipe3(
    .clk_in(clk), .RST(RST),
    .ctrl_in(ctrl_p2), .pc_in(pc_out_p2),
    .A_addr(A_addr), .B_addr(B_addr),
    .A(muxA_data), .B(muxB_data), .imm(imm),
    .pc_chg(pc_chg_p1), .pc_out(pc_in_p1),
    .mem_we(mem_we_p3), .data(data_p3), .addr(addr_p3),
    .reg_addr(reg_addr_p3), .ctrl_out(ctrl_out_p3)
);

pipeline4 pipe4(
    .clk_in(clk), .RST(RST),
    .ctrl_in(ctrl_out_p3),
    .we(mem_we_p3), .data(data_p3), .addr(addr_p3),
    .reg_addr_in(reg_addr_p3),
    .reg_data_out(reg_data_out_p4), .reg_addr_out(reg_addr_out_p4),
    .ctrl_out(ctrl_out_p4)
);

pipeline5 pipe5(
    .clk_in(clk), .RST(RST),
    .ctrl_in(ctrl_out_p4),
    .data(reg_data_out_p4), .addr(reg_addr_out_p4),
    .data_out(reg_data_p2), .addr_out(reg_addr_p2), .en_out(reg_en_p2)
);

endmodule

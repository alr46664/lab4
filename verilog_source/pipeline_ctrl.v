module pipeline_ctrl(
    clk, RST, // clk e reset
    A_addr,   // endereco dos registradores decodificados no pipe 2
    B_addr,
    ctrl,     // indica operacao a ser executada (ainda nao foi pro pipeline 3)
	ctrl_p34, // ctrl pipe 3-4
	ctrl_p45, // ctrl pipe 4-5
	reg_en_p52, // enable reg pipe 5-2
    reg_addr_p34,    // controle de hazards - ADDR
    reg_addr_p45,
    reg_addr_p52,
    reg_dataA_p2,         // controle de hazards - selecao de dados - dados em p2
    reg_dataB_p2,
    reg_data_p34,        // data entre p3-4
    reg_data_p45,        // data entre p4-5
    reg_data_p52,        // data entre p5-2
    muxA_data,      // saida dos multiplexadores - entrada de p3
    muxB_data
    );

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// input output
input clk, RST;
input [REG_ADDR_WIDTH-1:0] A_addr, B_addr;
input [CTRL_WIDTH-1:0] ctrl, ctrl_p34, ctrl_p45;
input reg_en_p52;
input [REG_ADDR_WIDTH-1:0] reg_addr_p34, reg_addr_p45, reg_addr_p52;
input signed [DATA_WIDTH-1:0] reg_dataA_p2, reg_dataB_p2, reg_data_p34,reg_data_p45, reg_data_p52;

output reg signed [DATA_WIDTH-1:0] muxA_data, muxB_data;

// TODO controle dos hazards do processador
// usando como informacao :
    // input [CTRL_WIDTH-1:0] ctrl;
    // input [REG_ADDR_WIDTH-1:0] A_addr (reg_addrA_p23), B_addr (reg_addrB_p23), reg_addr_p34, reg_addr_p45, reg_addr_p52;
    // input signed [DATA_WIDTH-1:0] reg_dataA_p2, reg_dataB_p2, reg_data_p34, reg_data_p45, reg_data_p52;
// gerando como saida:
    // output reg signed [DATA_WIDTH-1:0] muxA_data, muxB_data;
always @(*) begin
    // por default coloque o mux (input do p3)
    // com os dados do p2
    muxA_data = reg_dataA_p2;
    muxB_data = reg_dataB_p2;

    if (A_addr == reg_addr_p34 && ctrl_p34 != NOP) begin
        // atualize os dados que chegam em p3 para os dados que estao entre p3-4
        muxA_data = reg_data_p34;
    end else if (A_addr == reg_addr_p45 && ctrl_p45 != NOP) begin
        // atualize os dados que chegam em p3 para os dados que estao entre p4-5
        muxA_data = reg_data_p45;
    end else if (A_addr == reg_addr_p52 && reg_en_p52 == 1) begin
        // atualize os dados que chegam em p3 para os dados que estao entre p5-2
        muxA_data = reg_data_p52;
    end

    if (B_addr == reg_addr_p34 && ctrl_p34 != NOP) begin
        // atualize os dados que chegam em p3 para os dados que estao entre p3-4
        muxB_data = reg_data_p34;
    end else if (B_addr == reg_addr_p45 && ctrl_p45 != NOP) begin
        // atualize os dados que chegam em p3 para os dados que estao entre p4-5
        muxB_data = reg_data_p45;
    end else if (B_addr == reg_addr_p52 && reg_en_p52 == 1) begin
        // atualize os dados que chegam em p3 para os dados que estao entre p5-2
        muxB_data = reg_data_p52;
    end
end

endmodule

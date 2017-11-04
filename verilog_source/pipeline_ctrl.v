module pipeline_ctrl(
    clk, RST, // clk e reset
    A_addr,   // endereco dos registradores decodificados no pipe 2
    B_addr,
    ctrl,     // indica operacao a ser executada (ainda nao foi pro pipeline 3)
    done_p1,  // input - pipelines terminaram de executar?
    done_p2,
    done_p3,
    done_p4,
    done_p5,
    clk_p1,   // controla o funcionamento do pipeline
    clk_p2,
    clk_p3,
    clk_p4,
    clk_p5,
    reg_addr_p34,    // controle de hazards - ADDR
    reg_addr_p45,
    reg_addr_p52,
    reg_dataA_p2,         // controle de hazards - selecao de dados - dados em p2
    reg_dataB_p2,
    reg_data_p34,        // data entre p3-4
    reg_data_p45,        // data entre p4-5
    reg_data_p52,        // data entre p5-2
    muxA_data,      // saida dos multiplexadores - entrada de p3
    muxB_data,
    eof             // indica que processador terminou de executar o programa
    );

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// input output
input clk, RST;
input [REG_ADDR_WIDTH-1:0] A_addr, B_addr;
input [CTRL_WIDTH-1:0] ctrl;
input done_p1, done_p2, done_p3, done_p4, done_p5;
input [REG_ADDR_WIDTH-1:0] reg_addr_p34, reg_addr_p45, reg_addr_p52;
input signed [DATA_WIDTH-1:0] reg_dataA_p2, reg_dataB_p2, reg_data_p34,reg_data_p45, reg_data_p52;

output reg eof;
output reg clk_p1, clk_p2, clk_p3, clk_p4, clk_p5;
output reg signed [DATA_WIDTH-1:0] muxA_data, muxB_data;

// variaveis auxiliares
reg [1:0] stage_pipe; // contador da execucao dos estagios do pipeline

// incremente contador de execucao dos pipelines
always @(posedge clk_p3 or negedge RST) begin
    if (!RST) begin
        // reset
        stage_pipe <= 0;
    end else begin
        stage_pipe <= stage_pipe + 1;
    end
end

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

    if (A_addr == reg_addr_p34) begin
        // atualize os dados que chegam em p3 para os dados que estao entre p3-4
        muxA_data = reg_data_p34;
    end else if (A_addr == reg_addr_p45) begin
        // atualize os dados que chegam em p3 para os dados que estao entre p4-5
        muxA_data = reg_data_p45;
    end else if (A_addr == reg_addr_p52) begin
        // atualize os dados que chegam em p3 para os dados que estao entre p5-2
        muxA_data = reg_data_p52;
    end

    if (B_addr == reg_addr_p34) begin
        // atualize os dados que chegam em p3 para os dados que estao entre p3-4
        muxB_data = reg_data_p34;
    end else if (B_addr == reg_addr_p45) begin
        // atualize os dados que chegam em p3 para os dados que estao entre p4-5
        muxB_data = reg_data_p45;
    end else if (B_addr == reg_addr_p52) begin
        // atualize os dados que chegam em p3 para os dados que estao entre p5-2
        muxB_data = reg_data_p52;
    end
end

// controle dos estagios do pipeline
always @(clk or negedge RST) begin
    if (!RST) begin
        // reset
        clk_p1 <= 0;
        clk_p2 <= 0;
        clk_p3 <= 0;
        clk_p4 <= 0;
        clk_p5 <= 0;
    end else begin
        clk_p1 <= clk;
        clk_p2 <= (done_p1 ? clk : 0);
        clk_p3 <= (done_p2 ? clk : 0);
        clk_p4 <= (done_p3 ? clk : 0);
        clk_p5 <= (done_p4 ? clk : 0);
        case(ctrl)
        EOF: begin
            // paralize o pipeline 1 e 2 (chegamos ao fim do programa)
            clk_p1 <= 0;
            clk_p2 <= 0;
            eof    <= 1;
            // nao iremos paralizar os estagios 3, 4 e 5 pq elas podem estar
            // executando alguma operacao remanescente
        end
        default: begin
            // nao faca nada de proposito
        end
        endcase
    end
end

endmodule

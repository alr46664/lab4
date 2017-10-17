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
    eof       // indica que processador terminou de executar o programa
    );

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// input output
input clk, RST;
input [REG_ADDR_WIDTH-1:0] A_addr, B_addr;
input [CTRL_WIDTH-1:0] ctrl;
input done_p1, done_p2, done_p3, done_p4, done_p5;

output reg eof;
output reg clk_p1, clk_p2, clk_p3, clk_p4, clk_p5;

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

// // TODO controle dos hazards do processador
// always @(clk or negedge RST) begin
//     if (!RST) begin
//         // reset

//     end else begin

//     end
// end

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
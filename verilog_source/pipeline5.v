module pipeline5(
    clk_in,
    RST,
    ctrl_in,
    data,
    addr,
    data_out,
    addr_out,
    en_out,
    done
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// input / output
input clk_in, RST;
input [CTRL_WIDTH-1:0] ctrl_in;
input signed [DATA_WIDTH-1:0] data;
input [REG_ADDR_WIDTH-1:0] addr;

output reg signed [DATA_WIDTH-1:0] data_out;
output reg [REG_ADDR_WIDTH-1:0] addr_out;
output reg en_out, done;

// execucao da gravacao nos registradores
always @(negedge clk_in or negedge RST) begin
    if (!RST) begin
        // rotina de reset
        data_out  <= 0;
        addr_out  <= 0;
        en_out    <= 0;
        done      <= 0;
    end else begin
        data_out  <= data;
        addr_out  <= addr;
        // TODO implementar o controle de
        // gravacao do pipeline 5 (abaixo)
        en_out    <= 0;
        done      <= 1;
    end
end


endmodule
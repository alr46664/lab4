module pipeline4(
    clk_in,
    RST,
    ctrl_in,
    data,
    addr,
    reg_addr_in,
    reg_data_out,
    reg_addr_out,
    ctrl_out,
    done
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

input clk_in, RST;
input [CTRL_WIDTH-1:0] ctrl_in;
input signed [DATA_WIDTH-1:0] data;
input [MEM_WIDTH-1:0] addr;
input [REG_ADDR_WIDTH-1:0] reg_addr_in;

output reg signed [DATA_WIDTH-1:0] reg_data_out;
output reg [REG_ADDR_WIDTH-1:0] reg_addr_out;
output reg [CTRL_WIDTH-1:0] ctrl_out;
output reg done;

// repasse o control
always @(posedge clk_in) begin
    ctrl_out    <= ctrl_in;
end

// execucao da gravacao em memoria do pipeline 4
always @(negedge clk_in or negedge RST) begin
    if (!RST) begin
        // rotina de reset
        reg_data_out  <= 0;
        reg_addr_out  <= 0;
        done          <= 0;
    end else begin
        // TODO implementar o pipeline 4
        reg_data_out  <= 0;
        reg_addr_out  <= 0;
        done          <= 1;
    end
end

endmodule
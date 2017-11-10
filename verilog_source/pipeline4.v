module pipeline4(
    clk_in,
    RST,
    ctrl_in,
    we,
    data,
    addr,
    reg_addr_in,
    reg_data_out,
    reg_addr_out,
    ctrl_out
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

input clk_in, RST;
input [CTRL_WIDTH-1:0] ctrl_in;
input we;
input signed [DATA_WIDTH-1:0] data;
input [MEM_WIDTH-1:0] addr;
input [REG_ADDR_WIDTH-1:0] reg_addr_in;

output wire signed [DATA_WIDTH-1:0] reg_data_out;
output reg [REG_ADDR_WIDTH-1:0] reg_addr_out;
output reg [CTRL_WIDTH-1:0] ctrl_out;

//instancias
mem_data rom0(.clk(clk_in), .we(we), .addr(addr), .data_in(data), .data_out(reg_data_out));

// repasse do endereco de registrador
always @(posedge clk) begin
  reg_addr_out <= reg_addr_in;
end

// reset do sistema
always @(posedge clk_in) begin
    if (!RST) begin
      // rotina de reset
      ctrl_out    <= NOP;
    end else begin
      ctrl_out    <= ctrl_in;
    end
end

endmodule

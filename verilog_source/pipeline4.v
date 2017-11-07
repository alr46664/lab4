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

output wire signed [DATA_WIDTH-1:0] reg_data_out;
output reg [REG_ADDR_WIDTH-1:0] reg_addr_out;
output reg [CTRL_WIDTH-1:0] ctrl_out;
output reg done;

// varaiveis auxiliares
reg we;
wire clk_mem;

//instancias
mem_data rom0(.clk(clk_mem), .we(we), .addr(addr), .data_in(data), .data_out(reg_data_out));

// gere clk da memoria
assign clk_mem = !clk_in;

// repasse o control
always @(posedge clk_in) begin
    ctrl_out    <= ctrl_in;
end

// execucao da gravacao em memoria do pipeline 4
always @(posedge clk_in or negedge RST) begin
    if (!RST) begin
        // rotina de reset
        reg_addr_out  <= 0;
        we <= 0;
        done          <= 0;
    end else begin
        reg_addr_out  <= reg_addr_in;
        done          <= 1;
        case (ctrl_in)							
          SW: begin
             we <= 1;
          end          	  
		  default: begin
              we <= 0;
		  end
          endcase		          
    end
end

endmodule
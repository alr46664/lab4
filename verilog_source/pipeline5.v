module pipeline5(
    clk_in,
    RST,
    ctrl_in,
    data,
    addr,
    data_out,
    addr_out,
    en_out
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
output reg en_out;

// repasse dos enderecos data e addr
always @(posedge clk_in) begin
    data_out <= data;
    addr_out <= addr;
end

// execucao da gravacao nos registradores
always @(posedge clk_in) begin
    if (!RST) begin
        // rotina de reset
        en_out    <= 0;
	end else begin
        // Case para controle de habilitação de escrita no registrador de acordo com o opcode de entrada.
        case (ctrl_in)
        // ------------ Data Trasnfer -----------------
        LW:       en_out <= 1;
        LW_IMM:   en_out <= 1;
        // ------------ Arithmetic -----------------
        ADD:      en_out <= 1;
        SUB:      en_out <= 1;
        MUL:      en_out <= 1;
        DIV:      en_out <= 1;
        // ------------ Lógic -----------------
        AND:      en_out <= 1;
        OR :      en_out <= 1;
        NOT:      en_out <= 1;
        // ------------ Control Transfer -----------------
        // All default
        default:  en_out <= 0;
        endcase
	 end
end


endmodule

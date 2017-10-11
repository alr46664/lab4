module compl2( data1,      // operando 1
            out        // saida de dados
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

input [DATA_WIDTH-1:0] data1;

output reg [DATA_WIDTH-1:0] out;

always @(data1) begin
	out = (~ data1) + 1;
end

endmodule
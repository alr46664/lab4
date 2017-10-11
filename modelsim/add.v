module add( data1,      // operando 1
            data2,      // operando 2
            out,        // saida de dados
            overflow    // indica overflow
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

input [DATA_WIDTH-1:0] data1, data2;

output reg [DATA_WIDTH-1:0] out;
output reg overflow;

always @(data1,data2) begin
	overflow = 0;
	out = data1 + data2;
	// iremos verificar overflow agora
    case(out[DATA_WIDTH-1])
    1'b0: begin
        // neste caso, sabemos que houve overflow pois ambos data1
        // e data2 sao negativos e a saida out deu positiva
        if (data1[DATA_WIDTH-1] == 1 && data2[DATA_WIDTH-1] == 1) begin
            overflow = 1;
        end
    end
    default: begin
        // neste caso, sabemos que houve overflow pois ambos data1
        // e data2 sao positivos e a saida out deu negativa
        if (data1[DATA_WIDTH-1] == 0 && data2[DATA_WIDTH-1] == 0) begin
            overflow = 1;
        end
    end
    endcase
end

endmodule
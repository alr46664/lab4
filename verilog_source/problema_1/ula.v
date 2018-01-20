module ula( opcode,     // codigo da instrucao
            data1,      // operando 1
            data2,      // operando 2
            out,        // saida de dados
            rflags      // saida - registrador de flags do processador
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// entradas e saidas
input [OPCODE_WIDTH-1:0] opcode;
input signed [DATA_WIDTH-1:0] data1, data2;

output reg signed [DATA_WIDTH-1:0] out;
output reg [RFLAGS_WIDTH-1:0] rflags;

// variaveis auxiliares
reg xor_data12_sign;
reg signed [DATA_WIDTH-1:0] data2_aux;

always @(*) begin
    // defina default das saidas
    out = data1;
    rflags = 0;
	 data2_aux = 0;
    xor_data12_sign = data1[DATA_WIDTH-1] ^ data2[DATA_WIDTH-1];
    // execute a operacao
    if (opcode == ADD || opcode == SUB || opcode == CMP) begin
        // neste caso, verificaremos se SUB e faremos o complemento de 2
        data2_aux = (opcode == SUB || opcode == CMP ? (~ data2) + 1 : data2);
        out = data1 + data2_aux;
        // iremos verificar overflow agora
        case(out[DATA_WIDTH-1])
        1'b0: begin
            // neste caso, sabemos que houve overflow pois ambos data1
            // e data2 sao negativos e a saida out deu positiva
            if (data1[DATA_WIDTH-1] == 1 && data2_aux[DATA_WIDTH-1] == 1) begin
                rflags[4] = 1;
            end
        end
        default: begin
            // neste caso, sabemos que houve overflow pois ambos data1
            // e data2 sao positivos e a saida out deu negativa
            if (data1[DATA_WIDTH-1] == 0 && data2_aux[DATA_WIDTH-1] == 0) begin
                rflags[4] = 1;
            end
        end
        endcase
    end else if (opcode == MUL) begin
        out = data1 * data2;
        // iremos verificar overflow agora
        case(out[DATA_WIDTH-1])
        1'b0: begin
            // neste caso, sabemos que houve overflow pois ou data1
            // ou data2 e negativo e a saida deveria ser negativa
            // (porem e positiva)
            if (xor_data12_sign == 1) begin
                rflags[4] = 1;
            end
        end
        default: begin
            // neste caso, sabemos que houve overflow pois data1
            // e data2 possuem mesmo sinal (positivo ou negativo)
            // Logo a saida deveria ser positiva (porem e negativa)
            if (xor_data12_sign == 0) begin
                rflags[4] = 1;
            end
        end
        endcase
    end else if (opcode == DIV) begin
        if (data2 != 0) begin
            out = data1 / data2;
        end else begin
            // erro - divisao por zero
            rflags[0] = 1;
        end
        // nao precisamos verificar overflow (divisao nao causa overflow)
    end else if (opcode == AND) begin
        out = data1 & data2;
    end else if (opcode == OR) begin
        out = data1 | data2;
    end else if (opcode == NOT) begin
        out = (data1 == 0 ? 1 : 0) ;
    end

    if (opcode == CMP) begin
        if (out == 0) begin
            // neste caso data1 == data2 pois data1-data2 == 0
            rflags = 5'b00100;
        end else if (xor_data12_sign) begin
            // os dados possuem sinais diferentes
            if (data1[DATA_WIDTH-1]) begin
                // neste caso data1 < data2 pois data1 < 0 e data2 >= 0
                rflags = 5'b00010;
            end else begin
                // neste caso data1 > data2 pois data1 >= 0 e data2 < 0
                rflags = 5'b01000;
            end
        end else begin
            // os dados possuem mesmo sinal
            if (out[DATA_WIDTH-1]) begin
                // neste caso data1 < data2 pois data1-data2 < 0
                rflags = 5'b00010;
            end else begin
                // neste caso data1 > data2 pois data1-data2 > 0
                rflags = 5'b01000;
            end
        end
    end
end

endmodule
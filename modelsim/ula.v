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
output reg [4:0] rflags;

// variaveis auxiliares
reg xor_data12_sign;
reg [DATA_WIDTH-1:0] data1_aux, data2_aux, out_aux;

// declaracao dos sinais das instanciacoes abaixo
reg [DATA_WIDTH-1:0] compl2_in;
reg [DATA_WIDTH-1:0] add_in1, add_in2;
reg [DATA_WIDTH-1:0] mul_in1, mul_in2;
wire [DATA_WIDTH-1:0] compl2_out, compl2_out2, compl2_out3;
wire [DATA_WIDTH-1:0] add_out, mul_out;
wire add_overflow, mul_overflow;

// instanciacoes
compl2 compl20(.data1(compl2_in), .out(compl2_out));
add    add0(.data1(add_in1), .data2(add_in2), .out(add_out), .overflow(add_overflow));
mul    mul0(.data1(mul_in1), .data2(mul_in2), .out(mul_out), .overflow(mul_overflow));

always @(*) begin
    // defina default das saidas
    out = 0;
    rflags = 0;
    xor_data12_sign = data1[DATA_WIDTH-1] ^ data2[DATA_WIDTH-1];
    // execute a operacao
    if (opcode == ADD) begin
        add_in1 = data1;
        add_in2 = data2;
        out = add_out;
        rflags[4] = add_overflow;
    end else if (opcode == SUB || opcode == CMP) begin
        add_in1 = data1;
        compl2_in = data2;
        add_in2 = compl2_out;
        out = add_out;
        rflags[4] = add_overflow;
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
        if (add_out == 0) begin
            // neste caso data1 == data2 pois data1-data2 == 0
            rflags[2] = 1;
        end else if (add_out[DATA_WIDTH-1] == 0) begin
            // neste caso data1 > data2 pois data1-data2 > 0
            rflags[3] = 1;
        end else begin
            // neste caso data1 < data2 pois data1-data2 > 0
            rflags[1] = 1;
        end
    end
end

endmodule
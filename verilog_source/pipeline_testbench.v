module pipeline_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// input output
reg clk_in, RST;

// instancia testada
pipeline pipe(.clk_in(clk_in), .RST(RST));

// inicializando testes
initial begin
    // inicilizacao dos inputs
    clk_in = 0;
    // faca rotina de reset
    RST = 1;
    #3;
    RST = 0;
    #3;
    RST = 1;
end

// gerando clock
always begin
    // gere o clock quando os sinais de teste estiverem estabilizados
    #4;
    clk_in = !clk_in;
end


endmodule
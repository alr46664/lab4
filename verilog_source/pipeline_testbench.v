module pipeline_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// input output
reg clk, RST;

// instancia testada
pipeline pipe(.clk(clk), .RST(RST));

// inicializando testes
initial begin
    // inicilizacao dos inputs
    clk = 0;
    // faca rotina de reset
    RST = 1;
    #1;
    RST = 0;
    #1;
    RST = 1;
end

// gerando clock
always begin
    // gere o clock quando os sinais de teste estiverem estabilizados
    #4;
    clk = !clk;
end


endmodule
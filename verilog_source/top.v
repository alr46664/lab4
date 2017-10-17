//Bloco TOP

module top(
    clk,
    RST
    );

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// input / output do top
input clk;
input RST;

// instacias

// pipeline todo esta aqui
pipeline pipe(
	.clk(clk), .RST(RST)
	);

// TODO implementar o sistema de interrupcao
// em uma instancia aqui em baixo


endmodule

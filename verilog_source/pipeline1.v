module pipeline1(
	clk_in,    // clock_in
	RST,       // reset
	pc_in,     // entrada - contador de programa
	instr,     // instrucao 		
	pc_out,    // saida - contador de programa    
    done // saidas estaveis
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada

input clk_in, RST;
input [PC_WIDTH-1:0] pc_in;

// declaracao de saida

output [INSTR_WIDTH-1:0] instr;
output reg [PC_WIDTH-1:0] pc_out;
output reg done;

wire we;

assign we = 0;
//write enable igual a 0, pois aqui e apenas leitura da instrucao na memoria
mem_program mem_inst(.clk(clk_in), .we(we), .addr(pc_in), .data_in(0), .data_out(instr));


always @(posedge clk_in or negedge RST) begin	
	if (!RST)
		begin	
			pc_out <= PC_INITIAL; // reset - PC vai pro valor inicial
			done <= 0; // saidas instaveis
		end	
	else 
		begin	
			pc_out <= pc_in + 4;		//determinando o endereço da próxima instrução		
			done <= 1;					// saidas estaveis (== 1)
		end
end

endmodule
module pic(
	clk,     	// clock
	intr_in,    // recebe sinal do processador 
	intr_out,   // envia sinal para o processador
	intr_cod,   // codigo da interrupção
	data_in,    // dados recebidos
	data_out,   // dados para transmissão	
	data_en,    // sinal para informar que os dados estão prontos para serem enviados
	RST	      // reset
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao das entradas
input clk, RST;
input wire intr_in; 
input [IRQ_WIDTH-1:0] intr_cod;
input [DATA_WIDTH-1:0] data_in;

// declaracao das saidas
output reg signed [DATA_WIDTH-1:0] data_out
output reg intr_out; 

// configuração do reset 
always @(posedge RST) begin
	if (!RST) begin
		intr_out <= 1'b0;        // seta o controle de aviso do processador para negativo. (basicamente informa o processador que houve uma interrupção. Atrasvés do intr_in o processador avisa esse modulo que está pronto para receber os dados)
		data_out <= 16'bx;       // dados desconhecidos.
		data_en  <= 1'b0;        // seta o controle de envio de dados para o processador para negativo.
	end	
end

 
// controle das interrupções 

always @(*) begin 	
	case(intr_cod)begin
		IRQ_0:begin
			             			 // avisa processador sobre interrupção;
		end		
		default: begin           // nenhuma interrupção conhecida, desconsiderar!
			intr_out <= 1'b0;     // seta o controle de aviso do processador para negativo		
			data_out <= 16'bx;    // dados desconhecidos		
		end 
	endcase
	
	if(intr_in) begin           //houve resposta do processador. Enviar dados!		
		data_out = data_in;      // repassa os dados
		data_en = 1'b1;		    // habilita o controle de envio de dados para avisar o processador que os dados estão preparados para o envio.
	end
end 



endmodule

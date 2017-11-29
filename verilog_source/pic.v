module pic(
	clk,     			// clock
	intr_in,    		// recebe sinal do processador dizendo que está apto a receber a interrupção	
	intr_out,    		// recebe sinal do processador dizendo que está apto a receber a interrupção	
	intr_vect,   		// envia sinal para o processador (Diz ao pipe 1 existe uma interrupção)	
	data_in,    		// sinal para informar que os dados estão prontos para serem enviados 
	data_out,   		// dados para transmissão		
	RST	      		// reset
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao das entradas
input clk, RST;
input wire intr_in; 
input [IRQ_VECTOR_INTR-1:0] intr_vect;
input [(4*DATA_WIDTH)-1:0] data_in;

// declaracao das saidas
output reg signed [DATA_WIDTH-1:0] data_out;
output reg intr_out; 

// parametros locais
localparam  [1:0]   Reset    = 2'b00,
						  Process  = 2'b01,
                    Complete = 2'b10;  
	
               
// parametros auxiliares
reg [1:0] state, state_next; 				
reg [IRQ_VECTOR_INTR-1: 0] aux_intr_vect;
reg [IRQ_VECTOR_INTR-1:0] end_vect_int = 256'b1111; // Finaliza o loop apos varrer as 16 primeiras interrupções


// configuração do reset 
always @(posedge clk) begin
	if (!RST) begin
		state <=  Reset;		
	end
	else begin
		state <= state_next;    		
	end
end

 
// controle das interrupções 

always @(*) begin 
	state_next = state;	
	
	case(state)
		Reset: begin 			 
			aux_intr_vect = 256'b0;  // restarta index de busca do vetor de interrupção
			state_next = Process;  // seta processo inicial
			data_out = 7'bz;  //valor high na saida 
			intr_out = 1'b0; // desativa sinalização para o pipe
		end
	
		Process: begin	
			if (aux_intr_vect == end_vect_int) begin // bloqueia loop infinito				
				state_next = Reset;				
			end
			else if (intr_vect[aux_intr_vect] == 1) begin // caso encontre vai informa o pic e aguarda resposta
				//data_out =  // como pegar os dados?????
				intr_out = 1'b1;			  
				state_next = Complete;        
			end 
			else begin // Caso não encontre a interrupção procurar pela seguinte mais prioritária				
				aux_intr_vect = aux_intr_vect + 1'b1;
				state_next = Process;			
			end
		end
		
		Complete: begin
			if(intr_in)begin
				state_next = Reset;        
			end
			else begin
				state_next = Complete;        
			end 
		end		
	endcase
end 

endmodule

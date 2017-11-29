module pic(
    clk,     			// clock
    RST,	      		// reset
    interruption_rec,   // sinal do pipeline que informa recebimento da interrupção	
    data_in,    		// dados de entrada dos dispositivos conectados
    interruption_vec,   // vetor de interrupcoes	
    interruption_send,  // sinal enviado ao pipeline informando ocorrencia de interrupcao
    interruption_id,   	// id da interrupcao que ocorreu
    data_out            // dados para transmissão		
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao das entradas
input clk, RST, interruption_rec;
input [(DEVICES_QTD*DATA_WIDTH)-1:0] data_in;
input [(1<<INTERRUPT_WIDTH)-1:0] interruption_vec;

// declaracao das saidas
output reg interruption_send; 
output reg [INTERRUPT_WIDTH-1:0] interruption_id;
output reg signed [DATA_WIDTH-1:0] data_out;


// estados da maquina 
parameter Reset    = 2'b00,
          Process  = 2'b01,
          Complete = 2'b10;  
    
               
// variaveis auxiliares
reg [1:0] state, state_next;                          // controle de estados	
reg [(DEVICES_QTD*DATA_WIDTH)-1:0] data;              // armazenamento de dados (evita meta instabilidade em data_in)
reg [(1<<INTERRUPT_WIDTH)-1:0] aux_interruption_vec;  // contador usado para poll do vetor de interrupcao

// sinal que indica o comeco dos dados da interrupcao
// o tamanho desse sinal é igual a [lg2(DEVICES_QTD*DATA_WIDTH):0]
wire [7:0] interruption_data_begin;                   

assign interruption_data_begin = interruption_id * DATA_WIDTH;

// registrador de proximo estado
always @(posedge clk) begin
    if (!RST) begin
        state <=  Reset;		
    end
    else begin
        state <= state_next;    		
    end
end

// decodificador de proximo estado e saida
always @(state) begin 
    // salva os dados em um registrador interno (evita meta-instabilidade)
    data = data_in;
    
    state_next = state;	
    
    case(state)
        Reset: begin 			 
            state_next = Process;    
            // reset
            aux_interruption_vec = 1;  // reinicia busca do vetor de interrupção
            data                 = 0;  // reinicia registrador de dados
            interruption_id      = 0;  
            data_out             = 0;  
            interruption_send    = 0;  // nao ha interrupcoes sendo processadas        
        end
    
        Process: begin
            if (interruption_vec & aux_interruption_vec != 0) begin 
                // sabemos que houve uma interrupcao identificada por aux_interruption_vec                
                interruption_send = 1;			  
                interruption_id   = interruption_id;
                // se isto ocorrer, sabemos que estamos lidando com uma interrupcao externa
                // logo temos que selecionar os dados do dispositivo                 
                if (interruption_id < DEVICES_QTD) begin
                    data_out = data[interruption_data_begin+DATA_WIDTH-1 : interruption_data_begin];
                end else begin                  
                    // interrupcao interna, nao ha dados externos pra enviar
                    data_out = 0;
                end
                state_next = Complete;        
            end 
            else begin 
                // continue procurando interrupcoes
                aux_interruption_vec = aux_interruption_vec << 1;
                interruption_id      = interruption_id + 1;
                data_out             = 0;  
                interruption_send    = 0;  // nao ha interrupcoes sendo processadas        
                state_next = Process;			
            end
        end
        
        Complete: begin
            // mantenha dados estaveis ate finalizar o processo de
            // passar interrupcoes pro pipeline 1
            interruption_id      = interruption_id;  
            data_out             = data_out;  
            interruption_send    = interruption_send;  
            if(interruption_rec)begin
                state_next = Reset;        
            end
            else begin
                state_next = Complete;        
            end 
        end		
    endcase
end 

endmodule

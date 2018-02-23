module pic(
    clk,     			// clock
    RST,	      		// reset
    data_in,    		// dados de entrada dos dispositivos conectados
    interruption_vec,   // vetor de interrupcoes
    interruption_send,  // sinal enviado ao pipeline informando a existencia de uma instrucao de interrupcao
    interruption_instr  // instrucao da interrupcao a ser executada
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao das entradas
input clk, RST, interruption_rec;
input [(DEVICES_QTD*DATA_WIDTH)-1:0] data_in;
input [(1<<INTERRUPT_WIDTH)-1:0] interruption_vec;

// declaracao das saidas
output reg interruption_send;
output reg [INSTR_WIDTH-1:0] interruption_instr;

// estados da maquina
parameter RESET          = 3'b000,
          PROCESS        = 3'b001,
          LOAD_DATA_REG  = 3'b010,
          STORE_DATA     = 3'b011,
          RESTORE_REG    = 3'b100,
          CALL_INTERRUPT = 3'b101,
          COMPLETE       = 3'b110;

// variaveis auxiliares
reg [1:0] state, state_next;                          // controle de estados
reg [(1<<INTERRUPT_WIDTH)-1:0] aux_interruption_vec;  // contador usado para poll do vetor de interrupcao

// id da interrupcao e seus dados
reg [INTERRUPT_WIDTH-1:0] interruption_id;
reg signed [DATA_WIDTH-1:0] data_out;

// sinal que indica o comeco dos dados da interrupcao
// o tamanho desse sinal é igual a [lg2(DEVICES_QTD*DATA_WIDTH):0]
wire [7:0] interruption_data_begin;

// mapeamento dos irqs em memoria
wire [MEM_WIDTH-1:0] mapeamento;

// calculo do inicio dos dados da interrupcao externa
assign interruption_data_begin = interruption_id * DATA_WIDTH;

// calculo do mapeamento em memoria
assign mapeamento = (1 << MEM_WIDTH) - 1 - interruption_id;

// registrador de proximo estado
always @(posedge clk) begin
    if (!RST) begin
        state <= RESET;
    end else begin
        state <= state_next;
    end
end

// decodificador de proximo estado e saida
always @(state) begin
    state_next = state_next;
    case(state)
        // reset do pic
        RESET: begin
            state_next = PROCESS;
            // reset
            aux_interruption_vec = 1;  // reinicia busca do vetor de interrupção
            interruption_id      = 0;
            data_out             = 0;

            interruption_send    = 0;  // nao ha interrupcoes sendo processadas
            interruption_instr   = 0;
        end

        // fase de processamento (busca de interrupcao)
        PROCESS: begin
            // nenhuma interrupcao disponivel pro pipe 1
            interruption_send  = 0;
            interruption_instr = 0;
            // default values
            data_out             = 0;
            interruption_id      = interruption_id;
            aux_interruption_vec = aux_interruption_vec;
            // sabemos que houve uma interrupcao identificada por aux_interruption_vec
            if (interruption_vec & aux_interruption_vec != 0) begin
                // se isto ocorrer, sabemos que estamos lidando com uma interrupcao externa
                // logo temos que selecionar os dados do dispositivo
                if (interruption_id < DEVICES_QTD) begin
                    data_out = data_in[interruption_data_begin+DATA_WIDTH-1 : interruption_data_begin];
                    // temos dados a carregar na memoria de dados
                    state_next = LOAD_DATA_REG;
                end else begin
                    // interrupcao interna, nao ha dados externos pra enviar
                    state_next = LOAD_PROG_REG;
                end
            end else begin
                // continue procurando interrupcoes
                aux_interruption_vec = aux_interruption_vec << 1;
                interruption_id      = interruption_id + 1;
                state_next           = PROCESS;
            end
        end

        // faz o LW dos dados em um registrador auxiliar
        LOAD_DATA_REG: begin
            // mantenha sinais estaveis
            data_out             = data_out;
            interruption_id      = interruption_id;
            aux_interruption_vec = aux_interruption_vec;
            // gere a saida (a ordem dos sinais aqui importa! send deve vir por ultimo!)
            interruption_instr = {data_out, REG_AUX_0, REG_AUX_1, LW_IMM};
            interruption_send  = 1;
            // proximo estado
            state_next = STORE_DATA;
        end

        // armazena dados do registrador auxiliar (SW) em memoria
        STORE_DATA: begin
            // mantenha sinais estaveis
            data_out             = data_out;
            interruption_id      = interruption_id;
            aux_interruption_vec = aux_interruption_vec;
            // gere a saida (a ordem dos sinais aqui importa! send deve vir por ultimo!)
            interruption_instr = {mapeamento, REG_AUX_0, REG_AUX_1, SW};
            interruption_send  = 1;
            // proximo estado
            state_next = LOAD_PROG_REG;
        end

        // coloca no regitrador auxiliar o mapeamento da memoria de programa
        // (posicao da funcao de interrupcao)
        LOAD_PROG_REG: begin
            // mantenha sinais estaveis
            data_out             = data_out;
            interruption_id      = interruption_id;
            aux_interruption_vec = aux_interruption_vec;
            // gere a saida (a ordem dos sinais aqui importa! send deve vir por ultimo!)
            interruption_instr = {mapeamento, REG_AUX_0, REG_AUX_1, LW_IMM};
            interruption_send  = 1;
            // proximo estado
            state_next = CALL_INTERRUPT;
        end

        // chama rotina de interrupcao (mapeamento da mem dados = mapeamento da mem programa)
        CALL_INTERRUPT: begin
            // mantenha sinais estaveis
            data_out             = data_out;
            interruption_id      = interruption_id;
            aux_interruption_vec = aux_interruption_vec;
            // gere a saida (a ordem dos sinais aqui importa! send deve vir por ultimo!)
            interruption_instr = {16'b0, REG_AUX_0, REG_AUX_1, CALL};
            interruption_send  = 1;
            // proximo estado
            state_next = RESTORE_REG;
        end

        // restaura valor original do registrador auxiliar
        RESTORE_REG: begin
            // mantenha sinais estaveis
            data_out             = data_out;
            interruption_id      = interruption_id;
            aux_interruption_vec = aux_interruption_vec;
            // gere a saida (a ordem dos sinais aqui importa! send deve vir por ultimo!)
            interruption_instr = {16'h0001, REG_AUX_0, REG_AUX_1, LW_IMM};
            interruption_send  = 1;
            // proximo estado
            state_next = COMPLETE;
        end

        // fim de envio de interrupcao pro pipe 1
        COMPLETE: begin
            // mantenha dados estaveis ate finalizar o processo de
            // passar interrupcoes pro pipeline 1
            interruption_send    = 0;
            interruption_instr   = 0;
            data_out             = 0;
            interruption_id      = 0;
            aux_interruption_vec = 1;
            // reseta
            state_next = RESET;
        end
    endcase
end

endmodule

module pic(
	clk,     	// clock
	intr_in,    // recebe sinal do processador (O pipe 1 avisa que esta pronto para receber os dados)
	intr_out,   // envia sinal para o processador (Diz ao pipe 1 existe uma interrupção)
	intr_cod,   // codigo da interrupção (IRQ's)
	data_in,    // dados recebidos (Dados recebidos pelo dispositovo que relaiza a interrupção)
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

// parametros locais
localparam  [3:0]   S_Reset                 = 4'b0000,  // Reset or start state                    
										S_GetCommands           = 4'b0001,  // Command mode - set polling or priority mode
                    S_JumpIntMethod         = 4'b0010,  // Determine which mode was selected                    
                    S_StartPriority         = 4'b0111,  // Start priority check
                    S_TxIntInfoPriority     = 4'b1000,  // Assert intr_out if interrupt present and sent source ID on intr_bus
                    S_AckTxInfoRxPriority   = 4'b1001,  // Wait for intr_in to go high
                    S_AckISRDonePriority    = 4'b1010;  // De-assert intr_out signal
                    

// parametros auxiliares
reg     [3:0]   state_reg, state_next;          // State registers
reg     [1:0]   cmdCycle_reg, cmdCycle_next;    // Machine cycle
reg     [2:0]   intrIndex_reg, intrIndex_next;  // Cycle through all 8 in polling
reg     [2:0]   intrPtr_reg, intrPtr_next;      // Interrupt pointer
reg     [IRQ_WIDTH - 1:0]   prior_table_next [0:7]; 
reg     [IRQ_WIDTH - 1:0]   prior_table_reg [0:7];
reg             oe_reg, oe_next;                // Output enable for the bidirectional bus
reg     [7:0]   intrBus_reg, intrBus_next;      // Bus <= register if using bus as output
reg             intrOut_reg, intrOut_next;      // Interrupt output


// configuração do reset 
always @(posedge clk or posedge RST) begin
	if (!RST) begin
		state_reg           <=  S_Reset;
		cmdMode_reg         <=  2'b00;
		cmdCycle_reg        <=  2'b00;
		oe_reg              <=  1'b0;
		intrBus_reg         <=  8'bzzzzzzzz;
		intrOut_reg         <=  1'b0;
		intrIndex_reg       <=  3'b000;
		intrPtr_reg         <=  3'b000;
		for (i = 0; i < 16; i = i + 1) begin
		  prior_table_reg[i]  <=  3'b000;
		end
  else begin
		state_reg           <=  state_next;    
		cmdCycle_reg        <=  cmdCycle_next;
		intrBus_reg         <=  intrBus_next;
		intrOut_reg         <=  intrOut_next;
		oe_reg              <=  oe_next;
		intrIndex_reg       <=  intrIndex_next;
		intrPtr_reg         <=  intrPtr_next;
		for (i = 0; i < 16; i = i + 1) begin
		  prior_table_reg[i]  <=  prior_table_next[i];
		end
	end
end

 
// controle das interrupções 

always @(*) begin 
	state_next          =   state_reg;
	cmdMode_next        =   cmdMode_reg;
	cmdCycle_next       =   cmdCycle_reg;
	oe_next             =   oe_reg;
	intrOut_next        =   intrOut_reg;
	intrBus_next        =   intrBus_reg;
	intrIndex_next      =   intrIndex_reg;
	intrPtr_next        =   intrPtr_reg;
	for (i = 0; i < 16; i = i + 1) begin
		prior_table_next[i] =   prior_table_reg[i];
	end
	case(state_reg)begin
		
		// GET COMMANDS
		S_GetCommands: begin
			prior_table_next[0] = IRQ_0;
			prior_table_next[1] = IRQ_1;
			prior_table_next[2] = IRQ_2;
			prior_table_next[3] = IRQ_3;
			prior_table_next[4] = IRQ_4;
			prior_table_next[5] = IRQ_5;
			prior_table_next[6] = IRQ_6;
			prior_table_next[7] = IRQ_7;
			prior_table_next[8] = IRQ_8;
			prior_table_next[9] = IRQ_9;
			prior_table_next[10] = IRQ_10;
			prior_table_next[11] = IRQ_11;
			prior_table_next[12] = IRQ_12;
			prior_table_next[13] = IRQ_13;
			prior_table_next[14] = IRQ_14;
			prior_table_next[15] = IRQ_15;
			state_next = S_JumpIntMethod;
		end
		default: begin
			state_next  =   S_GetCommands;
		end 
		
		// JUMP INTO METHOD
		S_JumpIntMethod: begin // 4'b0010
			intrIndex_next  =   3'b000;
			intrPtr_next    =   3'b000;

			// State priority.
			state_next  =   S_StartPriority;
			
			//intrBus_next    =   8'bzzzzzzzz;            // The bus is tristated.
			oe_next         =   1'b0;                   // Controller is not driving the bus.
		end
		
		
		S_StartPriority: begin // 4'b0111
			if (intr_cod == prior_table_reg[0]) begin              // Check if the highest priority source is active.
			  intrPtr_next    =   prior_table_reg[0];         // If the highest priority interrupt is active,
			  intrOut_next    =   1'b1;                       // set the output high.
			  state_next      =   S_TxIntInfoPriority;        // Go wait for acknowledgement.
			end

			else if (intr_cod == prior_table_reg[1]) begin         // Else check the next highest priority.
			  intrPtr_next    =   prior_table_reg[1];         // Continue as above.
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else if (intr_cod == prior_table_reg[2]) begin
			  intrPtr_next    =   prior_table_reg[2];
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else if (intr_cod == prior_table_reg[3]) begin
			  intrPtr_next    =   prior_table_reg[3];
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else if (intr_cod == prior_table_reg[4]) begin
			  intrPtr_next    =   prior_table_reg[4];
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else if (intr_cod == prior_table_reg[5]) begin
			  intrPtr_next    =   prior_table_reg[5];
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else if (intr_cod == prior_table_reg[6]) begin
			  intrPtr_next    =   prior_table_reg[6];
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else if (intr_cod == prior_table_reg[7]) begin
			  intrPtr_next    =   prior_table_reg[7];
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end
			else if (intr_cod == prior_table_reg[8]) begin           
			  intrPtr_next    =   prior_table_reg[8];         
			  intrOut_next    =   1'b1;                       
			  state_next      =   S_TxIntInfoPriority;        
			end

			else if (intr_cod == prior_table_reg[9]) begin         
			  intrPtr_next    =   prior_table_reg[9];         
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else if (intr_cod == prior_table_reg[10]) begin
			  intrPtr_next    =   prior_table_reg[10];
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else if (intr_cod == prior_table_reg[11]) begin
			  intrPtr_next    =   prior_table_reg[11];
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else if (intr_cod == prior_table_reg[12]) begin
			  intrPtr_next    =   prior_table_reg[12];
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else if (intr_cod == prior_table_reg[13]) begin
			  intrPtr_next    =   prior_table_reg[13];
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else if (intr_cod == prior_table_reg[14]) begin
			  intrPtr_next    =   prior_table_reg[14];
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else if (intr_cod == prior_table_reg[15]) begin
			  intrPtr_next    =   prior_table_reg[15];
			  intrOut_next    =   1'b1;
			  state_next      =   S_TxIntInfoPriority;
			end

			else begin                                          
			  state_next  =   S_StartPriority;                
			end

			//intrBus_next    =   8'bzzzzzzzz;                    
			oe_next         =   1'b0;                           
		end
		
		S_TxIntInfoPriority: begin // 4'b1000
			if (~intr_in) begin                                 
				intrOut_next    =   1'b0;                       
				intrBus_next    =   {5'b10011, intrPtr_reg};    
				oe_next         =   1'b1;                       
				state_next      =   S_AckTxInfoRxPriority;      
			end                                                 
		end
		
		S_AckTxInfoRxPriority: begin // 4'b1001
			if (~intr_in) begin                                 
				//intrBus_next    =   8'bzzzzzzzz;               
				oe_next         =   1'b0;                       
				state_next      =   S_AckISRDonePriority;       
			end
		end
		
		S_AckISRDonePriority: begin // 4'b1010
			// If the proper source and condition has been acknowleged, check next interrupt.
			//if ((~intr_in) && (intr_bus[7:3] == 5'b01100) && (intr_bus[2:0] == intrPtr_reg)) begin
				//state_next  =   S_StartPriority;
			//end
			// Else, the controller assumes this to be an error. (If the condition codes are wrong).
			// In that case it returns to reset state.
			//else if ((~intr_in) && (intr_bus[7:3] != 5'b01100) && (intr_bus[2:0] != intrPtr_reg)) begin
				//state_next  =   S_Reset;
			//end
			//else begin
				//state_next  =   S_AckISRDonePriority;           // Else wait in the current state.
			//end
		end

	endcase
end 
endmodule

module pilha_ctrl(
    active,
    RST,
    instr, 
    pc_in,
    pc_out,
    error
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao input / output
input active, RST;
input [CTRL_WIDTH-1:0] instr;
input [PC_WIDTH-1:0] pc_in;

output [PC_WIDTH-1:0] pc_out;
output error;

// variaveis auxiliares
reg [PILHA_CTRL_WIDTH-1:0] p_ctrl;

// instancia da pilha
pilha pilha0(	
	.active(active),      
	.data_in(pc_in),   
	.ctrl(p_ctrl),      
	.data_out(pc_out),  
	.error(error)      
);

//  -------   CONTROLE DA PILHA   --------

// defina a funcao a ser executada (PUSH / POP / RESET)
always @(*) begin
    if (!RST) begin
      // reset
      p_ctrl = PILHA_RESET;
    end else if (instr == CALL) begin
      p_ctrl = PILHA_PUSH;
    end else if (instr == RET) begin
      p_ctrl = PILHA_POP;      
    end else begin
      // o default e o reset
      p_ctrl = PILHA_RESET;      
    end
end

endmodule
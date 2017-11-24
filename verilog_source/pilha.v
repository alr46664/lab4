module pilha(	
	active,      // faz a operacao na memoria
	data_in,    // dados a serem gravados na pilha
	ctrl,       // controle da pilha
	data_out,   // dados no topo da pilha
	error      // erro (overflow, underflow)
);

// include dos parameters
`include "params_proc.v"

// declaracao dos sinais
input active;
input [PILHA_CTRL_WIDTH-1:0] ctrl;
input [PC_WIDTH-1:0] data_in; 

output reg error;
output [PC_WIDTH-1:0] data_out;

// declaracao das variaveis
wire [PILHA_WIDTH-1:0] topo_real;
reg [PC_WIDTH-1:0] regs [0:(1<<PILHA_WIDTH)-1];
reg [PILHA_WIDTH-1:0] topo;

// leitura do topo da pilha
assign data_out = regs[topo_real];

// ultimo dado da pilha (topo real)
assign topo_real = topo - 1;

// controle de gravacao na pilha
always@(active) begin
	case (ctrl)
	PILHA_PUSH: begin
		if (topo_real == (1<<PILHA_WIDTH)-1) begin
		  	error = 1;
		end else begin
			error = 0;
			regs[topo] = data_in;
			topo = topo + 1;				
		end
	end
	PILHA_POP: begin
		if (topo == 0) begin
		  	error = 1;
		end else begin
			error = 0;
			topo = topo_real;					
		end		
	end	
	default: begin
		// reset
		error = 0;
		topo = 0;		
	end
	endcase
end		
	
endmodule


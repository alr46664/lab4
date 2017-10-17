module pipeline3(
	clk_in,    // clock_in
	RST,       // reset
    ctrl_in,   // controller do processador
	pc_in,     // entrada - contador de programa
	A_addr,    // endereco do reg A
    B_addr,    // endereco do reg B
	A,         // dados do reg A
	B,         // dados do reg B
	imm,       // dados do imediato
	pc_chg,    // indica alteracao do PC
	pc_out,    // indica alteracao do PC
    data,      // dados computados
    addr,      // endereco de memoria computado
    reg_addr,  // endereco do registrador para gravacao
    ctrl_out,  // controller do processador
    done       // saidas estaveis
);

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// declaracao de entrada / saida
input clk_in, RST;
input [CTRL_WIDTH-1:0] ctrl_in;
input [PC_WIDTH-1:0] pc_in;
input [REG_ADDR_WIDTH-1:0] A_addr, B_addr;
input signed [DATA_WIDTH-1:0] A, B, imm;

output reg [PC_WIDTH-1:0] pc_out;
output reg signed [DATA_WIDTH-1:0] data;
output reg [MEM_WIDTH-1:0] addr;
output reg [REG_ADDR_WIDTH-1:0] reg_addr;
output reg [CTRL_WIDTH-1:0] ctrl_out;
output reg pc_chg, done;

// variaveis auxiliares
reg  [RFLAGS_WIDTH-1:0] rflags_last;
wire signed [DATA_WIDTH-1:0] B_imm;

// controla se a saida de ula vai pra data,
// ou pra addr (== 0 vai pra data, do contrario
// vai pra addr)
reg ula_to_data;
reg signed [DATA_WIDTH-1:0] data_default;
reg [MEM_WIDTH-1:0] addr_default;

// sinais da ula
reg signed [DATA_WIDTH-1:0] ula_data1, ula_data2;
reg [OPCODE_WIDTH-1:0] ula_opcode;
wire signed [DATA_WIDTH-1:0] ula_out;
wire [RFLAGS_WIDTH-1:0] rflags;

// instancias de outros modulos
ula ula0(.opcode(ula_opcode),
	.data1(ula_data1), .data2(ula_data2),
	.out(ula_out), .rflags(rflags));

// armazene o rflags
always @(negedge clk_in or negedge RST) begin
	if (!RST) begin
		rflags_last  <= 0;
	end else begin
		rflags_last <= rflags;
	end
end

// repasse o control
always @(posedge clk_in) begin
    ctrl_out    <= ctrl_in;
end

// execute a instrucao
always @(posedge clk_in or negedge RST) begin
	if (!RST) begin
		// rotina de reset
		pc_out      <= PC_INITIAL;
		reg_addr    <= 0;
		pc_chg 	    <= 0;
		// valores default dos regs internos
		ula_to_data    <= 0;
		data_default   <= 0;
		addr_default   <= 0;
		ula_opcode     <= NOP;
		ula_data1      <= 0;
		ula_data2      <= 0;
        // saidas instaveis
        done           <= 0;
	end	else begin
        pc_out      <= pc_in;
        reg_addr    <= A_addr;
        pc_chg      <= 0;
        // valores default dos regs internos
        ula_to_data    <= 1;
        data_default   <= 0;
        addr_default   <= 0;
        ula_opcode     <= NOP;
        ula_data1      <= 0;
        ula_data2      <= 0;
		// saidas estaveis (== 1)
        done           <= 1;
		case(ctrl_in)
		LW: begin
    		// pegue o conteudo presente no endereco de
    		// memoria B + IMM
    		ula_to_data    <= 0;
			ula_opcode     <= ADD;
    		ula_data1      <= B_imm;
    		ula_data2      <= 0;
    		// e armazene no registrador A
    		reg_addr       <= A_addr;
		end
        LW_IMM: begin
            // pegue o conteudo IMM
            ula_to_data    <= 1;
            ula_opcode     <= ADD;
            ula_data1      <= imm;
            ula_data2      <= 0;
            // e armazene no registrador A
            reg_addr       <= A_addr;
        end
		SW: begin
    		// armazene na memoria no endereco B + imm
    		ula_to_data    <= 0;
			ula_opcode     <= ADD;
    		ula_data1      <= B_imm;
    		ula_data2      <= 0;
    		// o conteudo de reg A
    		data_default   <= A;
		end
		JR: begin
			// desvie o pc para o endereco A
			pc_chg   <= 1;
			pc_out   <= A;
		end
		JPC: begin
			// devie o pc para o endereco B (== 0) + imm
			// relativo a PC
			pc_chg   <= 1;
			pc_out   <= pc_in + B_imm;
		end
		BRFL: begin
			// verifique se RFlags[i] == Const
			if (rflags_last[imm[RFLAGS_WIDTH-1:0]] == B) begin
				// faremos agora o desvio para o endereco R (== A)
				pc_chg   <= 1;
				pc_out   <= A;
			end
		end
		CALL: begin
			// grave no registrador de retorno de funcao
    		reg_addr     <= REG_FUNC_RET;
    		// o valor do pc atual
    		ula_to_data  <= 1;
			ula_opcode   <= ADD;
	        ula_data1    <= pc_in;
	        ula_data2    <= 0;
	        // e altere o pc para a funcao chamada
			pc_chg   <= 1;
			pc_out   <= A;
		end
		RET: begin
			// altere o pc para o retorno da chamada de funcao,
			// armazenado em A
			pc_chg   <= 1;
			pc_out   <= A;
		end
		NOP: begin
			// nao faca nada de proposito
		end
        EOF: begin
            // nao faca nada de proposito
        end
		default: begin
    		// armazene no registrador A
    		reg_addr    <= A_addr;
    		// os dados resultantes da operacao ula_opcode
    		ula_to_data <= 1;
			ula_opcode  <= ctrl_in;
			// entre A, e B + imm
			ula_data1   <= A;
	        ula_data2   <= B_imm;
		end
		endcase
	end
end

// redirecione a saida da ula pra data ou addr
always @(*) begin
	if (ula_to_data) begin
		data <= ula_out;
		addr <= addr_default;
	end else begin
		data <= data_default;
		addr <= ula_out;
	end
end

// soma de B com imediato
assign B_imm = B + imm;

endmodule
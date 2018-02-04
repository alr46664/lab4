module pipeline1_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// numero de testes a serem feitos
parameter N_TESTES = 7;

// memoria de programa (instrucoes do processador)
reg [INSTR_WIDTH-1:0] ram [0:(1<<MEM_WIDTH)-1];

// declaracao input / output
reg clk_in, RST, pc_chg;
reg [PC_WIDTH-1:0] pc_in;

wire [INSTR_WIDTH-1:0] instr;
wire [PC_WIDTH-1:0] pc_out;

// criacao das instancias
pipeline1 pipeline10(
	.clk_in(clk_in),
	.RST(RST),
	.pc_chg(pc_chg),
	.pc_in(pc_in),
	.instr(instr),
	.pc_out(pc_out)
	);

// inicializa os inputs do modulo (acima) a ser testado
task init_input;
begin
    pc_chg = 0;
	pc_in = 0;
	// inicializacao da memoria de programa
	$readmemb("../assembler/program.bin", ram);
end
endtask

// executa o teste numero 'testes' emitindo status como resultado do teste
task execute_test;
    input integer testes;
    output reg status;

    // dados dos testes
    parameter TESTE1_CHG = 0,
        TESTE1_IN = 3;        

	parameter TESTE2_CHG = 0,
        TESTE2_IN = 4;        

	parameter TESTE3_CHG = 1,
        TESTE3_IN = 6;        

	parameter TESTE4_CHG = 0,
        TESTE4_IN = 1;        

	parameter TESTE5_CHG = 1,
        TESTE5_IN = 2;        

	parameter TESTE6_CHG = 0,
        TESTE6_IN = 10;        

begin
	// este atraso e necessario para estabilizacao do sinal da leitura da memoria
	#1
    case(testes)
	0: begin
	    pc_chg <= TESTE1_CHG;
	    pc_in  <= TESTE1_IN;				
		if (pc_out == PC_INITIAL+2 && instr == ram[pc_out-1]) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	1: begin
	    pc_chg <= TESTE2_CHG;
	    pc_in  <= TESTE2_IN;
		if (pc_out == PC_INITIAL+3 && instr == ram[pc_out-1]) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	2: begin
	    pc_chg <= TESTE3_CHG;
	    pc_in  <= TESTE3_IN;
		if (pc_out == PC_INITIAL+4 && instr == ram[pc_out-1]) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	3: begin
		pc_chg <= TESTE4_CHG;
	    pc_in  <= TESTE4_IN;
		if (pc_out == TESTE3_IN+1 && instr == ram[pc_out-1]) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	4: begin
		pc_chg <= TESTE5_CHG;
	    pc_in  <= TESTE5_IN;
		if (pc_out == TESTE3_IN+2 && instr == ram[pc_out-1]) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	5: begin
		pc_chg <= TESTE6_CHG;
	    pc_in  <= TESTE6_IN;
		if (pc_out == TESTE5_IN+1 && instr == ram[pc_out-1]) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
	end
	default: begin			
		status <= 0;
	end
	endcase
end
endtask

// mostra as entradas no console
task display_input;
    input integer testes;
    input reg status;
begin
    $display("  Teste # %2d  =>  ", testes);
    $display("\t ------ ENTRADAS -------  ");
    $display("\t PC_CHG: %b  ",  pc_chg);
	$display("\t PC_IN:  %6d  ", pc_in);    
end
endtask

// mostra as saidas no console
task display_output;
    input integer testes;
    input reg status;
begin
    $display("\t ------ SAIDAS -------  ");
    $display("\t INSTR (%3d): %b  ", INSTR_WIDTH, instr);
	$display("\t PC_OUT: %6d  ", pc_out);	
end
endtask

// faz o include do modelo de testbench
// ESTE INCLUDE DEVE VIR POR ULTIMO !!!
`include "testbench.v"


endmodule

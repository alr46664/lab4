module mem_program_testbench;

	// faz o include dos parameters das instrucoes
	`include "params_proc.v"
	
	// declaracao de input / output
	reg clk;
	reg we;
	reg [MEM_WIDTH-1:0] addr;
	reg [INSTR_WIDTH-1:0] data_in;
	wire [INSTR_WIDTH-1:0] data_out;
	
	//cria a instancia de memoria
	mem_program mem_inst ( .clk(clk),.we(we),.addr(addr),.data_in(data_in), .data_out(data_out) );
	
	initial begin
	
		clk = 0;
		we = 0;
		addr = 0;
		data_in = 0;
		
		//testa para escrita na memoria (write enable(we) = 1)
		#10 we=1'b1; 
		
		#10 addr=16'b0000000000000001; data_in=32'b00000000000000000000000000000001;
		
		#10 addr=16'b0000000000000010; data_in=32'b00000000000000000000000000000010;
		
		#10 addr=16'b0000000000000011; data_in=32'b00000000000000000000000000000011;
		
		#10 addr=16'b0000000000000100; data_in=32'b00000000000000000000000000000100;
		
		#10 addr=16'b0000000000000101; data_in=32'b00000000000000000000000000000101;
		
		#10 addr=16'bxxxxxxxxxxxxxxxx; data_in=32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		
		#10 we=1'b0; 
		
		//testa para leitura na memoria (write enable(we) = 0)		
		
		#10 addr=16'b0000000000000001;
		
		#10 addr=16'b0000000000000010;
		
		#10 addr=16'b0000000000000011;
		
		#10 addr=16'b0000000000000100;
		
		#10 addr=16'b0000000000000101;
		
	end
	
	// gerando clock
	always #10 clk = ~clk;
	
	initial #150 $stop;
	
endmodule
module ula_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// contador de testes a serem feitos
integer testes;

// declaracao das input e output da ula
reg signed [OPCODE_WIDTH-1:0] opcode;
reg signed [DATA_WIDTH-1:0] data1, data2;

wire signed [DATA_WIDTH-1:0] out;
wire [4:0] rflags;

// instancia da ula
ula ula0(.opcode(opcode), .data1(data1), .data2(data2), .out(out), .rflags(rflags));

// inicializando testes em 0
initial begin
    testes = 0;
end

// Gerando testes
always begin
	#5;
	testes <= testes+1;
end

// print dos resultados
task print_results;
	begin
    	$write("  Teste # %2d  =>  Opcode: %b  |  RFlags = %b |  ", testes, opcode, rflags);
	    case(opcode)
	    ADD: begin
	    	$write("%6d + %6d = %6d", data1, data2, out);
	    end
	    SUB: begin
	    	$write("%6d - %6d = %6d", data1, data2, out);
	    end
	    MUL: begin
	    	$write("%6d * %6d = %6d", data1, data2, out);
	    end
	    DIV: begin
	    	$write("%6d / %6d = %6d", data1, data2, out);
	    end
	    AND: begin
	    	$write("%6d & %6d = %6d", data1, data2, out);
	    end
		OR: begin
	    	$write("%6d | %6d = %6d", data1, data2, out);
		end
		NOT: begin
	    	$write("! %6d = %6d", data1, out);
		end
		CMP: begin
	    	$write("%6d cmp %6d = %6d", data1, data2, out);
		end
		default: begin
	    	$write("%6d ?? %6d = %6d", data1, data2, out);
		end
	    endcase
	    $write("  |  RFlags (descricao) = ");
	    if (rflags[4] == 1) begin
		    $write("OVERFLOW + ");
	    end
	    if (rflags[3] == 1) begin
		    $write("ABOVE + ");
	    end
	    if (rflags[2] == 1) begin
		    $write("EQUAL + ");
	    end
	    if (rflags[1] == 1) begin
		    $write("BELOW + ");
	    end
	    if (rflags[0] == 1) begin
		    $write("ERROR");
	    end
	    $display(" ");
	end
endtask

// mostre os resultados dos testes aqui
always @(out,rflags) begin
	print_results();
end


// realize os testes aqui
always @(testes) begin
	case(testes)
	1: begin
		data1 = 5;
		data2 = 10;
		opcode = ADD;
	end
	2: begin
		data1 = 5;
		data2 = -5;
		opcode = ADD;
	end
	3: begin
		data1 = 5;
		data2 = -8;
		opcode = ADD;
	end
	4: begin
		data1 = 32767;
		data2 = 1;
		opcode = ADD;
	end
	5: begin
		data1 = 5;
		data2 = 3;
		opcode = SUB;
	end
	6: begin
		data1 = 5;
		data2 = 9;
		opcode = SUB;
	end
	7: begin
		data1 = 5;
		data2 = 5;
		opcode = SUB;
	end
	8: begin
		data1 = 0;
		data2 = 32768;
		opcode = SUB;
	end
	9: begin
		data1 = -1;
		data2 = 32768;
		opcode = SUB;
	end
	10: begin
		data1 = 0;
		data2 = 5;
		opcode = MUL;
	end
	11: begin
		data1 = 32767;
		data2 = 2;
		opcode = MUL;
	end
	12: begin
		data1 = 5;
		data2 = 2;
		opcode = MUL;
	end
	13: begin
		data1 = -5;
		data2 = -2;
		opcode = MUL;
	end
	14: begin
		data1 = -5;
		data2 = 2;
		opcode = MUL;
	end
	15: begin
		data1 = -5;
		data2 = 2;
		opcode = DIV;
	end
	16: begin
		data1 = 5;
		data2 = -3;
		opcode = DIV;
	end
	17: begin
		data1 = -10;
		data2 = -2;
		opcode = DIV;
	end
	18: begin
		data1 = 5;
		data2 = 5;
		opcode = DIV;
	end
	19: begin
		data1 = 0;
		data2 = 5;
		opcode = DIV;
	end
	20: begin
		data1 = 1;
		data2 = 5;
		opcode = DIV;
	end
	21: begin
		data1 = 6;
		data2 = 0;
		opcode = DIV;
	end
	22: begin
		data1 = 5;
		data2 = 7;
		opcode = AND;
	end
	23: begin
		data1 = 5;
		data2 = 7;
		opcode = OR;
	end
	24: begin
		data1 = 5;
		data2 = 7;
		opcode = NOT;
	end
	25: begin
		data1 = 0;
		data2 = 8;
		opcode = NOT;
	end
	26: begin
		data1 = -5;
		data2 = 8;
		opcode = CMP;
	end
	27: begin
		data1 = 5;
		data2 = -8;
		opcode = CMP;
	end
	28: begin
		data1 = 5;
		data2 = 8;
		opcode = CMP;
	end
	29: begin
		data1 = -32768;
		data2 = -32768;
		opcode = CMP;
	end
	30: begin
		data1 = 10;
		data2 = 6;
		opcode = CMP;
	end
	31: begin
		data1 = 32767;
		data2 = -1;
		opcode = CMP;
	end
	32: begin
		data1 = -32768;
		data2 = 32767;
		opcode = CMP;
	end
	33: begin
		data1 = 1;
		data2 = -32768;
		opcode = CMP;
	end
	34: begin
		data1 = 32767;
		data2 = 32767;
		opcode = CMP;
	end
	default: begin
		// nao faca nada de proposito
	end
	endcase
end

endmodule
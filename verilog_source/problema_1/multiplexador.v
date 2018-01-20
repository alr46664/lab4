module mux_4x1(in_1, in_2, in_3, in_4, sel_1, sel_2, out);
output reg out; //reg permite a reutilização em bloco always
input in_1, in_2, in_3, in_4, sel_1, sel_2;

always @(sel_1, sel_2)
begin
	case({sel_1, sel_2})
		0: out = in_1;
		1: out = in_2;
		2: out = in_3;
		3: out = in_4;
	default out = 1'bx;
	endcase
end
endmodule 
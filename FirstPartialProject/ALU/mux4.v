module mux4(mux_in_a,mux_in_b, mux_in_c, mux_in_d, mux_sel, mux_out);

input [3:0]mux_in_a,mux_in_b, mux_in_c, mux_in_d;
input [1:0]mux_sel;
output reg[3:0] mux_out;

always @(mux_in_a, mux_in_b, mux_in_c, mux_in_d,mux_sel)
begin
	
	if(mux_sel == 2'b00)
		mux_out = mux_in_a;
	else if(mux_sel == 2'b01)
		mux_out = mux_in_b;
	else if(mux_sel == 2'b10)
		mux_out = mux_in_c;
	else if(mux_sel == 2'b11)
		mux_out = mux_in_d;
	else
		mux_out = 2'bXX;

end

endmodule 
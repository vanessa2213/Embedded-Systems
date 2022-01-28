module mux_in (mux_in_a, mux_in_b, sel_mux_in, out);

input sel_mux_in;
input [15:0]mux_in_a;
input [15:0]mux_in_b;

output reg [15:0]out;

always @ (*)
begin
	if(!sel_mux_in)
		out = mux_in_a;
	else 
		out = mux_in_b;
end
	
endmodule 


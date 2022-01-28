module mux1b (mux1b_in, out);

input mux1b_in;
output reg out;

always @ (*)
begin
	if(mux1b_in)
		out = 1;
	else 
		out = 0;
end
	
endmodule 
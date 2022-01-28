module overflow (in, out);

input [15:0] in;

output reg out;


always @ (*)
begin
	if(in != 16'h0000)
		out = 1;
	else
		out = 0;
end


endmodule 
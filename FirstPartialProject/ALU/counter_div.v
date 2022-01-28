module counter_div (in,en_count , reset_a, out);

input en_count, reset_a;
input [3:0] in;
output reg [3:0] out;


always @ (en_count, reset_a)
begin
	if(reset_a)
	begin
		out = 4'd0;
	end
	else
		if(en_count)
			out = in + 4'd1;
		else
			out = in;

end

endmodule 
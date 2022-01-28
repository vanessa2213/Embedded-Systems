module compare (a, b, out);

input [15:0] a,b;

output reg out;


always @ (*)
	begin
		if ( b >= a)
			out = 1;
		else
			out = 0;
	
	end 
	
endmodule

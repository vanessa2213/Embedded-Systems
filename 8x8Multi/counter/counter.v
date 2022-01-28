module counter (clk, aclr_n, count_out);

input clk, aclr_n;
output reg [3:0]count_out;

always @ (posedge clk, negedge aclr_n)
begin
	if(!aclr_n)
		count_out <= 4'b0000;
	else
		count_out <= count_out + 4'b0001;
	
end

endmodule

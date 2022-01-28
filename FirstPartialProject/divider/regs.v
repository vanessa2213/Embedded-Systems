module regs (datain, clk, sclr_n, clk_ena, reg_out);

input datain;
input clk, sclr_n, clk_ena;
output reg reg_out;

always @ (posedge clk)
begin
	if(clk_ena)
		if (sclr_n == 1'b0)
			reg_out <= 0;
		else 
			reg_out <= datain;
	
end


endmodule 
		
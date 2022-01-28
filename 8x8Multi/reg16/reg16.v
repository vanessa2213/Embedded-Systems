module reg16 (datain, clk, sclr_n, clk_ena, reg_out);

input [31:0]datain;
input clk, sclr_n, clk_ena;
output reg [31:0] reg_out;

always @ (posedge clk)
begin
	if(clk_ena)
		if (sclr_n == 1'b0)
			reg_out <= 32'b0;
		else 
		reg_out <= datain;
	
end


endmodule 
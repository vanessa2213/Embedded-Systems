module shifter( inp, shift_cntrl, shift_out);

input [7:0] inp;
input [2:0] shift_cntrl;
output reg[31:0] shift_out;


always@(inp, shift_cntrl)
begin
	if(shift_cntrl == 3'b00)
		shift_out  = (inp);
	else if (shift_cntrl == 3'b001)
		shift_out  = (inp << 4);
	else if (shift_cntrl == 3'b010)
		shift_out  = (inp << 8);
	else if (shift_cntrl == 3'b011)
		shift_out  = (inp << 12);
	else if (shift_cntrl == 3'b100)
		shift_out  = (inp << 16);
	else if (shift_cntrl == 3'b101)
		shift_out  = (inp << 20);
	else if (shift_cntrl == 3'b110)
		shift_out  = (inp << 24);
	else
		shift_out = 32'hXXXX_XXXX;
end


endmodule 
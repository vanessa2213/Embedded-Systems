module shifter_div( inp, shift_cntrl, shift_out);

input [15:0] inp;
input shift_cntrl;
output reg[15:0] shift_out;


always@(shift_cntrl, inp)
begin
	if(shift_cntrl)
		shift_out  = (inp << 1);
	else 
		shift_out  = inp;
end


endmodule 
module sum(en_sum, in_a, in_b, count,out_sum );

input en_sum;
input [3:0]count;
input [15:0]in_a, in_b;

output reg [15:0] out_sum;

always @ (count, en_sum, in_a, in_b)
begin
	if(en_sum)
	begin
		case(count)
			4'b0000:  out_sum = in_a + in_b[15];
			4'b0001:  out_sum = in_a + in_b[14];
			4'b0010:  out_sum = in_a + in_b[13];
			4'b0011:  out_sum = in_a + in_b[12];
			4'b0100:  out_sum = in_a + in_b[11];
			4'b0101:  out_sum = in_a + in_b[10];
			4'b0110:  out_sum = in_a + in_b[9];
			4'b0111:  out_sum = in_a + in_b[8];
			4'b1000:  out_sum = in_a + in_b[7];
			4'b1001:  out_sum = in_a + in_b[6];
			4'b1010:  out_sum = in_a + in_b[5];
			4'b1011:  out_sum = in_a + in_b[4];
			4'b1100:  out_sum = in_a + in_b[3];
			4'b1101:  out_sum = in_a + in_b[2];
			4'b1110:  out_sum = in_a + in_b[1];
			4'b1111:  out_sum = in_a + in_b[0];
			default:  out_sum = 16'h0000;
			
		endcase
	end
	else
		out_sum = in_a;


end



endmodule 
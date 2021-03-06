module rest(en_rest, bits,count,zero, in_a, in_b, out_rest );

input zero, en_rest;
input [15:0]in_a, in_b;
input [3:0]count, bits;
output reg [15:0] out_rest;


always @ (zero, count, bits, en_rest, in_a, in_b)
begin
if(en_rest)
begin
	if(zero)
	begin
	

		/*case(count)
			4'b0000: out_rest = in_a[15] ;
			4'b0001: out_rest = in_a[15:14] ;
			4'b0010: out_rest = in_a[15:13] ;
			4'b0011: out_rest = in_a[15:12] ;
			4'b0100: out_rest = in_a[15:11] ;
			4'b0101: out_rest = in_a[15:10] ;
			4'b0110: out_rest = in_a[15:9] ;
			4'b0111: out_rest = in_a[15:8] ;
			4'b1000: out_rest = in_a[15:7] ;
			4'b1001: out_rest = in_a[15:6] ;
			4'b1010: out_rest = in_a[15:5] ;
			4'b1011: out_rest = in_a[15:4] ;
			4'b1100: out_rest = in_a[15:3] ;
			4'b1101: out_rest = in_a[15:2] ;
			4'b1110: out_rest = in_a[15:1] ;
			4'b1111: out_rest = in_a[15:0] ;
			default:  out_rest = 16'h0000;
			
		endcase*/
		out_rest = in_a;
	end
	/*else if (bits == 4'b0000)
	begin
	
		case(count)
			4'b0000: out_rest = in_a[15] - in_b[0];
			4'b0001: out_rest = in_a[15:14] - in_b[0];
			4'b0010: out_rest = in_a[15:13] - in_b[0];
			4'b0011: out_rest = in_a[15:12] - in_b[0];
			4'b0100: out_rest = in_a[15:11] - in_b[0];
			4'b0101: out_rest = in_a[15:10] - in_b[0];
			4'b0110: out_rest = in_a[15:9] - in_b[0];
			4'b0111: out_rest = in_a[15:8] - in_b[0];
			4'b1000: out_rest = in_a[15:7] - in_b[0];
			4'b1001: out_rest = in_a[15:6] - in_b[0];
			4'b1010: out_rest = in_a[15:5] - in_b[0];
			4'b1011: out_rest = in_a[15:4] - in_b[0];
			4'b1100: out_rest = in_a[15:3] - in_b[0];
			4'b1101: out_rest = in_a[15:2] - in_b[0];
			4'b1110: out_rest = in_a[15:1] - in_b[0];
			4'b1111: out_rest = in_a[15:0] - in_b[0];
			default:  out_rest = 16'h0000;
		endcase
	end
	else if (bits == 4'b0001)
	begin
	
		case(count)
			4'b0001: out_rest = in_a[15:14] - in_b[1:0];
			4'b0010: out_rest = in_a[15:13] - in_b[1:0];
			4'b0011: out_rest = in_a[15:12] - in_b[1:0];
			4'b0100: out_rest = in_a[15:11] - in_b[1:0];
			4'b0101: out_rest = in_a[15:10] - in_b[1:0];
			4'b0110: out_rest = in_a[15:9] - in_b[1:0];
			4'b0111: out_rest = in_a[15:8] - in_b[1:0];
			4'b1000: out_rest = in_a[15:7] - in_b[1:0];
			4'b1001: out_rest = in_a[15:6] - in_b[1:0];
			4'b1010: out_rest = in_a[15:5] - in_b[1:0];
			4'b1011: out_rest = in_a[15:4] - in_b[1:0];
			4'b1100: out_rest = in_a[15:2] - in_b[1:0];
			4'b1101: out_rest = in_a[15:2] - in_b[1:0];
			4'b1110: out_rest = in_a[15:1] - in_b[1:0];
			4'b1111: out_rest = in_a[15:0] - in_b[1:0];
			default:  out_rest = 16'h0000;
		endcase
		out_rest = in_a;
	end
	else if (bits == 4'b0010)
	begin
	
		case(count)
			4'b0010: out_rest = in_a[15:13] - in_b[2:0];
			4'b0011: out_rest = in_a[15:12] - in_b[2:0];
			4'b0100: out_rest = in_a[15:11] - in_b[2:0];
			4'b0101: out_rest = in_a[15:10] - in_b[2:0];
			4'b0110: out_rest = in_a[15:9] - in_b[2:0];
			4'b0111: out_rest = in_a[15:8] - in_b[2:0];
			4'b1000: out_rest = in_a[15:7] - in_b[2:0];
			4'b1001: out_rest = in_a[15:6] - in_b[2:0];
			4'b1010: out_rest = in_a[15:5] - in_b[2:0];
			4'b1011: out_rest = in_a[15:4] - in_b[2:0];
			4'b1100: out_rest = in_a[15:3] - in_b[2:0];
			4'b1101: out_rest = in_a[15:2] - in_b[2:0];
			4'b1110: out_rest = in_a[15:1] - in_b[2:0];
			4'b1111: out_rest = in_a[15:0] - in_b[2:0];
			default:  out_rest = 16'h0000;
		endcase
	end
	else if (bits == 4'b0011)
	begin
	
		case(count)
			4'b0011: out_rest = in_a[15:12] - in_b[3:0];
			4'b0100: out_rest = in_a[15:11] - in_b[3:0];
			4'b0101: out_rest = in_a[15:10] - in_b[3:0];
			4'b0110: out_rest = in_a[15:9] - in_b[3:0];
			4'b0111: out_rest = in_a[15:8] - in_b[3:0];
			4'b1000: out_rest = in_a[15:7] - in_b[3:0];
			4'b1001: out_rest = in_a[15:6] - in_b[3:0];
			4'b1010: out_rest = in_a[15:5] - in_b[3:0];
			4'b1011: out_rest = in_a[15:4] - in_b[3:0];
			4'b1100: out_rest = in_a[15:3] - in_b[3:0];
			4'b1101: out_rest = in_a[15:2] - in_b[3:0];
			4'b1110: out_rest = in_a[15:1] - in_b[3:0];
			4'b1111: out_rest = in_a[15:0] - in_b[3:0];
			default:  out_rest = 16'h0000;
		endcase
	end
	
	else if (bits == 4'b0100)
	begin
	
		case(count)
			4'b0100: out_rest = in_a[15:11] - in_b[4:0];
			4'b0101: out_rest = in_a[15:10] - in_b[4:0];
			4'b0110: out_rest = in_a[15:9] - in_b[4:0];
			4'b0111: out_rest = in_a[15:8] - in_b[4:0];
			4'b1000: out_rest = in_a[15:7] - in_b[4:0];
			4'b1001: out_rest = in_a[15:6] - in_b[4:0];
			4'b1010: out_rest = in_a[15:5] - in_b[4:0];
			4'b1011: out_rest = in_a[15:4] - in_b[4:0];
			4'b1100: out_rest = in_a[15:3] - in_b[4:0];
			4'b1101: out_rest = in_a[15:2] - in_b[4:0];
			4'b1110: out_rest = in_a[15:1] - in_b[4:0];
			4'b1111: out_rest = in_a[15:0] - in_b[4:0];
			default:  out_rest = 16'h0000;
		endcase
	end
	
	else if (bits == 4'b0101)
	begin
	
		case(count)
			4'b0101: out_rest = in_a[15:10] - in_b[5:0];
			4'b0110: out_rest = in_a[15:9] - in_b[5:0];
			4'b0111: out_rest = in_a[15:8] - in_b[5:0];
			4'b1000: out_rest = in_a[15:7] - in_b[5:0];
			4'b1001: out_rest = in_a[15:6] - in_b[5:0];
			4'b1010: out_rest = in_a[15:5] - in_b[5:0];
			4'b1011: out_rest = in_a[15:4] - in_b[5:0];
			4'b1100: out_rest = in_a[15:3] - in_b[5:0];
			4'b1101: out_rest = in_a[15:2] - in_b[5:0];
			4'b1110: out_rest = in_a[15:1] - in_b[5:0];
			4'b1111: out_rest = in_a[15:0] - in_b[5:0];
			default:  out_rest = 16'h0000;
		endcase
	end
	else if (bits == 4'b0110)
	begin
	
		case(count)
			4'b0110: out_rest = in_a[15:9] - in_b[6:0];
			4'b0111: out_rest = in_a[15:8] - in_b[6:0];
			4'b1000: out_rest = in_a[15:7] - in_b[6:0];
			4'b1001: out_rest = in_a[15:6] - in_b[6:0];
			4'b1010: out_rest = in_a[15:5] - in_b[6:0];
			4'b1011: out_rest = in_a[15:4] - in_b[6:0];
			4'b1100: out_rest = in_a[15:3] - in_b[6:0];
			4'b1101: out_rest = in_a[15:2] - in_b[6:0];
			4'b1110: out_rest = in_a[15:1] - in_b[6:0];
			4'b1111: out_rest = in_a[15:0] - in_b[6:0];
			default:  out_rest = in_a;
		endcase
	end
	
	else if (bits == 4'b0111)
	begin
	
		case(count)
			4'b0111: out_rest = in_a[15:8] - in_b[7:0];
			4'b1000: out_rest = in_a[15:7] - in_b[7:0];
			4'b1001: out_rest = in_a[15:6] - in_b[7:0];
			4'b1010: out_rest = in_a[15:5] - in_b[7:0];
			4'b1011: out_rest = in_a[15:4] - in_b[7:0];
			4'b1100: out_rest = in_a[15:3] - in_b[7:0];
			4'b1101: out_rest = in_a[15:2] - in_b[7:0];
			4'b1110: out_rest = in_a[15:1] - in_b[7:0];
			4'b1111: out_rest = in_a[15:0] - in_b[7:0];
			default:  out_rest = in_a;
		endcase
	end
	else if (bits == 4'b1000)
	begin
	
		case(count)
			4'b1000: out_rest = in_a[15:7] - in_b[8:0];
			4'b1001: out_rest = in_a[15:6] - in_b[8:0];
			4'b1010: out_rest = in_a[15:5] - in_b[8:0];
			4'b1011: out_rest = in_a[15:4] - in_b[8:0];
			4'b1100: out_rest = in_a[15:3] - in_b[8:0];
			4'b1101: out_rest = in_a[15:2] - in_b[8:0];
			4'b1110: out_rest = in_a[15:1] - in_b[8:0];
			4'b1111: out_rest = in_a[15:0] - in_b[8:0];
			default:  out_rest = in_a;
		endcase
	end
	
	else if (bits == 4'b1001)
	begin
	
		case(count)
			4'b1001: out_rest = in_a[15:6] - in_b[9:0];
			4'b1010: out_rest = in_a[15:5] - in_b[9:0];
			4'b1011: out_rest = in_a[15:4] - in_b[9:0];
			4'b1100: out_rest = in_a[15:3] - in_b[9:0];
			4'b1101: out_rest = in_a[15:2] - in_b[9:0];
			4'b1110: out_rest = in_a[15:1] - in_b[9:0];
			4'b1111: out_rest = in_a[15:0] - in_b[9:0];
			default:  out_rest = in_a;
		endcase
	end
	else if (bits == 4'b1010)
	begin
	
		case(count)
			4'b1010: out_rest = in_a[15:5] - in_b[10:0];
			4'b1011: out_rest = in_a[15:4] - in_b[10:0];
			4'b1100: out_rest = in_a[15:3] - in_b[10:0];
			4'b1101: out_rest = in_a[15:2] - in_b[10:0];
			4'b1110: out_rest = in_a[15:1] - in_b[10:0];
			4'b1111: out_rest = in_a[15:0] - in_b[10:0];
			default:  out_rest = in_a;
		endcase
	end
	else if (bits == 4'b1011)
	begin
	
		case(count)
			4'b1011: out_rest = in_a[15:4] - in_b[11:0];
			4'b1100: out_rest = in_a[15:3] - in_b[11:0];
			4'b1101: out_rest = in_a[15:2] - in_b[11:0];
			4'b1110: out_rest = in_a[15:1] - in_b[11:0];
			4'b1111: out_rest = in_a[15:0] - in_b[11:0];
			default:  out_rest = in_a;
		endcase
	end
	
	else if (bits == 4'b1100)
	begin
	
		case(count)
			4'b1100: out_rest = in_a[15:3] - in_b[12:0];
			4'b1101: out_rest = in_a[15:2] - in_b[12:0];
			4'b1110: out_rest = in_a[15:1] - in_b[12:0];
			4'b1111: out_rest = in_a[15:0] - in_b[12:0];
			default:  out_rest = 16'h0000;
		endcase
	end
	else if (bits == 4'b1101)
	begin
	
		case(count)
			4'b1101: out_rest = in_a[15:2] - in_b[13:0];
			4'b1110: out_rest = in_a[15:1] - in_b[13:0];
			4'b1111: out_rest = in_a[15:0] - in_b[13:0];
			default:  out_rest = 16'h0000;
		endcase
	end
	else if (bits == 4'b1110)
	begin
	
		case(count)
			4'b1110: out_rest = in_a[15:1] - in_b[14:0];
			4'b1111: out_rest = in_a[15:0] - in_b[14:0];
			default:  out_rest = 16'h0000;
		endcase
	end
	else if (bits == 4'b1111)
	begin
	
		case(count)
			4'b1111: out_rest = in_a[15:0] - in_b[15:0];
			default:  out_rest = 16'h0000;
		endcase
	end
	else
		out_rest = 16'h0000;
end*/
else
	out_rest = in_a - in_b;
end
else
	out_rest = in_a;
end

endmodule 
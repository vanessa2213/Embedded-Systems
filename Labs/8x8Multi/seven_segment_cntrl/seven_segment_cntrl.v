module seven_segment_cntrl(inp, seg_a, seg_b, seg_c, seg_d, seg_e,seg_f, seg_g);

input [3:0]inp;
output reg seg_a, seg_b, seg_c, seg_d,seg_e, seg_f, seg_g;

always @ *
begin
	case (inp)
		4'b0000: 	begin
					{seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = 7'b1111110;
					end
		4'b0001: 	begin
					{seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = 7'b0110000;
					end
		4'b0010: 	begin
					{seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = 7'b1101101;
					end
		4'b0011: 	begin
					{seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = 7'b1111001;
					end
		4'b0100: 	begin
					{seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = 7'b0110011;
					end	
		4'b0101: 	begin
					{seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = 7'b1011011;
					end
		4'b0110: 	begin
					{seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = 7'b1011111;
					end
		4'b0111: 	begin
					{seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = 7'b1110000;
					end		
		4'b1000: 	begin
					{seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = 7'b1111111;
					end
		4'b1001: 	begin
					{seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = 7'b1111011;
					end
		default: begin
					{seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} = 7'b1001111;
					end
	endcase
		
end

endmodule 
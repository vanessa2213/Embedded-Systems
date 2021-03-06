module multi16x16(dataa, datab, start, reset_a, clk, product16x16_out, done_flag,
						seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g);
	
	input   		  start, reset_a, clk;		//5 inputs 
	input	 [15:0] dataa, datab;
	output		  done_flag;
	output [31:0] product16x16_out;
	output seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g;
	wire [3:0] m1_out, m2_out; //mux outputs
	wire [7:0] product; //mult_4x4 product
	wire [3:0] state;
	wire clk_en, sclr;
	wire [3:0] in_sel;
	wire [2:0] sh_sel;
	wire [31:0] sh_out, added; 
	wire [3:0] count;
	
	
	mux4 m1 (.mux_in_a(dataa[3:0]),.mux_in_b(dataa[7:4]), .mux_in_c(dataa[11:8]), .mux_in_d(dataa[15:12]), .mux_sel(in_sel[3:2]), .mux_out(m1_out));
	
	mux4 m2 (.mux_in_a(datab[3:0]),.mux_in_b(datab[7:4]), .mux_in_c(datab[11:8]), .mux_in_d(datab[15:12]), .mux_sel(in_sel[1:0]), .mux_out(m2_out));
	
	mult4x4 mx4 (.dataa(m1_out), .datab(m2_out), .product(product));
	
	mult_control m_cntrl (.clk(clk), .reset_a(reset_a), .start(start), .count(count), .input_sel(in_sel), .shift_sel(sh_sel), .state_out(state), .done(done_flag), .clk_ena(clk_en), .sclr_n(sclr));
	
	counter cnt (.clk(clk), .aclr_n(!start), .count_out(count));
	
	shifter sh (.inp(product), .shift_cntrl(sh_sel), .shift_out(sh_out));
	
	adder a1 (.dataa(product16x16_out), .datab(sh_out), .sum(added));
	
	reg16 r16 (.datain(added), .clk(clk), .sclr_n(sclr), .clk_ena(clk_en), .reg_out(product16x16_out));
	
	seven_segment_cntrl seg7 (.inp(state), .seg_a(seg_a), .seg_b(seg_b), .seg_c(seg_c), .seg_d(seg_d), .seg_e(seg_e), .seg_f(seg_f), .seg_g(seg_g));


endmodule 
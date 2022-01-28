module divider(dividen, divisor, start, reset_a, clk, quotient,remainder, done, overflow );

input clk, start, reset_a;
input [15:0] dividen, divisor;
output [15:0] quotient, remainder;
output done, overflow;

wire [7:0]sel_bits;
wire [3:0] count, bits;
wire [15:0] out_shift_1,out_shift_2, out_muxin, out_sum, out_rest, reg16_in, sum_in;
wire sel_mux1b, add,clk_ena,shift_cntrl_1,shift_cntrl_2,sel_mux_in,goreq, count_done, zero, en_count, sclr_n, overflow_1, en_sum, en_rest,clk_ena_sum, clk_ena_rest;

wire re1,re2;
//quotient

mux1b  u1(.mux1b_in(sel_mux1b), .out(add));

adder_div  u2(.dataa(out_shift_2), .datab(add), .sum(reg16_in));

reg16_div  u3(.datain(reg16_in), .clk(clk), .sclr_n(sclr_n), .clk_ena(clk_ena), .reg_out(quotient));

shifter_div u4(.inp(quotient), .shift_cntrl(shift_cntrl_2), .shift_out(out_shift_2));

//reminder
mux_in  u5(.mux_in_a(dividen), .mux_in_b(remainder), .sel_mux_in(sel_mux_in), .out(out_muxin));
compare u6(.a(divisor), .b(out_muxin), .out(goreq));
count_bits u7(.in(divisor), .out(bits), .done(count_done));

rest	u8(.en_rest(en_rest),.bits(bits), .count(count),.zero(zero), .in_a(remainder), .in_b(divisor), .out_rest(out_rest));
shifter_div u9(.inp(out_rest), .shift_cntrl(shift_cntrl_1), .shift_out(out_shift_1));
sum 	  u10(.en_sum(en_sum),.in_a(sum_in), .in_b(dividen), .count(count),.out_sum(out_sum));

reg16  u11(.datain(out_sum), .clk(clk), .sclr_n(sclr_n), .clk_ena(clk_ena_sum), .reg_out(remainder));
counter_div u12(.in(count),.en_count(en_count) , .reset_a(reset_a), .out(count));

overflow u13(.in(remainder), .out(overflow));
reg16_div  u15(.datain(out_shift_1), .clk(clk), .sclr_n(sclr_n), .clk_ena(clk_ena_rest), .reg_out(sum_in));

div_control u14(.clk(clk), .goreq(goreq), .start(start), .count_done(count_done), .reset_a(reset_a), 
					 .count(count), .done(re1), .sel_mux_in(sel_mux_in), .sh_cnt1(shift_cntrl_1), .sh_cnt2(shift_cntrl_2), 
					 .sclr_n(sclr_n), .clk_ena(clk_ena), .mux1b(sel_mux1b), .en_count(en_count), .zero(zero), .en_sum(en_sum), .en_rest(en_rest),
					 .clk_ena_sum(clk_ena_sum), .clk_ena_rest(clk_ena_rest));

					 
regs r1(.datain(re1), .clk(clk), .sclr_n(sclr_n), .clk_ena(clk_ena), .reg_out(done));
//regs r2(.datain(re2), .clk(clk), .sclr_n(sclr_n), .clk_ena(clk_ena), .reg_out(sel_mux_in));
endmodule 
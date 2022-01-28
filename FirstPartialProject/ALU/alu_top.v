module alu_top(dataa, datab, opcode, start, reset_a, clk, out, carry_flag, zero_flag, done_flag);
	
	input [15:0] dataa, datab;
	input [3:0] opcode;
	input start,  reset_a, clk;
	output [31:0] out;
	output zero_flag, carry_flag, done_flag;
	
	wire done1;
	wire state;
	
	alu u1(.dataa(dataa), .datab(datab), .opcode(opcode), .start(start), .reset_a(reset_a), .clk(clk), .state(state), .out(out), .carry_flag(carry_flag), .zero_flag(zero_flag), .done_flag(done1));
	alu_control u2(.clk(clk), .reset_a(reset_a), .start(start), .done_in(done1), .done_out(done_flag), .state_out(state));

endmodule
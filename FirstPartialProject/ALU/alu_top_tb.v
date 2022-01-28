`timescale 1 ns/1 ns

module alu_top_tb();

	reg [15:0] dataa, datab;
	reg [3:0] opcode;
	reg start, reset_a, clk;
	wire [31:0] out;
	wire carry_flag, zero_flag, done_flag;
	
	alu_top alu_top_1(.dataa(dataa), .datab(datab), .opcode(opcode), .start(start), .reset_a(reset_a),
		.clk(clk), .out(out), .carry_flag(carry_flag), .zero_flag(zero_flag), .done_flag(done_flag));
		
	initial begin
		clk = 0;
		forever clk = #25 ~clk;
	end
	
	initial begin
		reset_a = 1'b1;
		#50 reset_a = 1'b0;
	end
	
	initial begin
		start = 1'b1;
		#50 ;
		forever begin
			start = 1'b1;
			#50 start = 1'b0;
			@(negedge done_flag) ;
			#25 reset_a = 1'b1;
			start = 1'b1;
			#50 reset_a = 1'b0;
		end
	end
	
	initial begin
		dataa = 8'h08;
		datab = 8'h02;
		opcode = 4'b0000;
		#50 ;
		forever begin
			@(negedge done_flag)
			#50 opcode = opcode + 1'b1;
		end
	end
endmodule	
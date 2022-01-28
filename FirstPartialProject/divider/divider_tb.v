`timescale 1 ns/1 ns


module divider_tb();

reg clk, reset_a, start;
reg [15:0] dividen, divisor;
wire [15:0] quotient, remainder;
wire  done, overflow;

divider	u1(.dividen(dividen), .divisor(divisor), .start(start), 
				.reset_a(reset_a), .clk(clk), .quotient(quotient), 
				.remainder(remainder), .done(done), .overflow(overflow));

initial begin
		clk = 0;
		forever clk = #25 ~clk;
	end


/*initial begin		
		dividen = 16'd8;
		divisor = 16'd2;
		reset_a = 1'b1;
		start = 0;
		#100 ;
		reset_a = 1'b0;
		#100 ;
		start = 1'b1;
		#100 ;
		start = 0;
		clk = 0;
		
end	*/
initial begin
		dividen = 16'd2;
		divisor = 16'd5;
end	

initial begin
		reset_a = 1'b1;
		#50 reset_a = 1'b0;
	end
initial begin
		start = 1'b0;
		#50 start = 1'b1;
		#50 start = 1'b0;
	end
		
/*always begin
clk = 0;
#50;
clk = 1;
#50;
end		
*/
	

	
	
endmodule 
module multi16x16_tb;

	
	reg 		start, reset_a, clk;		//5 inputs 
	reg	 [15:0] dataa, datab;
	wire		done_flag;
	wire [31:0] product16x16_out;
	wire seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g;


multi16x16 dut (.start(start),
			   .reset_a(reset_a), 
			   .clk(clk), 
			   .dataa(dataa), 
			   .datab(datab), 
			   .done_flag(done_flag),
			   .product16x16_out(product16x16_out),
				.seg_a(seg_a), 
				.seg_b(seg_b), 
				.seg_c(seg_c), 
				.seg_d(seg_d), 
				.seg_e(seg_e), 
				.seg_f(seg_f), 
				.seg_g(seg_g)
			   );
			  
	initial begin
		clk = 0;
		forever clk = #25 ~clk;
	end
	
	// Set the reset control
	initial begin
		reset_a = 1'b1;
		#50 reset_a = 1'b0;
	end

	// Set input values to control start signal
	initial begin
		start = 1'b1;
		#50 ;
		forever begin
			start = 1'b1;
			#50 start = 1'b0;
			@(negedge done_flag) ;
			#25 ;
		end
	end
	
	// Process to control data inputs
	initial begin
		dataa = 16'h00FF;
		datab = 16'hFEFF;
		#50 ;
		forever begin
			@(negedge done_flag)
			#25 dataa = dataa + 24;
			datab = datab + 51;
		end
	end
	



endmodule 
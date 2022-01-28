`timescale 1 ns/1 ns

module mult4x4_tb();

	// Wires and variables to connect to DUT
	reg [3:0] dataa, datab;
	wire [7:0] product;
	
	// Instantiate unit under test (adder)
	mult4x4 mult4x41 (.dataa(dataa), .datab(datab), .product(product));

	// Assign values to "dataa" and "datab" to test adder block
	initial begin
		dataa = 4'd0;	
		datab = 4'd2;
		forever
			#10 dataa = dataa + 3; 	//incrementing by 3 dataa every 10 ns
	end

endmodule
`timescale 1ns / 1ps
module i2c_tb();


	//inputs	
	reg 		clk;  	       //master clock
	reg 		reset;
	reg 		master_start;  //master needs to raise this signal to initialize the data transfer
	reg [6:0] 	addr_in;       //address that's being inserted into our module
	reg [7:0] 	data_in; 	   //data that's being inserted into our module
	reg 		read_write_bit;// 0 - write 	1 - read
	reg 		sda_in;
	//outputs
	wire 		sda;   		   //data line 
	wire 		scl; 		   //i2c clock
	wire[7:0] 	data_read;	   //data read from slave 
	wire 		reading; 	   //flag that shows whenever something is being read
	
	
	reg [3:0] i = 4'b0111;
	reg [7:0] rd_data = 8'hz;
	
i2c dut (.clk(clk),
	 .reset(reset),
	 .master_start(master_start),
	 .addr_in(addr_in),
	 .data_in(data_in),
	 .read_write_bit(read_write_bit),
	 .sda_in(sda_in),
	 .sda(sda),
	 .scl(scl),
	 .data_read(data_read),
	 .reading(reading)
	 );
					
	
			  
	initial begin
		clk = 0;
		forever clk = #5 ~clk;
	end

//The next function is implemented in order to simulate a slave sending back data to the i2c master controller
//We take the signal reading implemented just for simulation purposes, which comes from the read state
//Inside the fsm in our main module. We then proceed to send the data 1 bit by bit trough the sda_in which is intended
//to emulate a bidirectional main signal sda which in this case we implemented separetedely (one as an output, one as an 
//input). We send the data to our controller and it gives us back the signal data_read in the end.
always @ (negedge clk)
		if(read_write_bit==1 && reading==1)begin 
			sda_in = rd_data[i]; 
			if(i==0) begin
				sda_in = rd_data[0];
				
			end 
			else begin
				i = i-1; 
			end
		end 
		else begin
			i = 4'b0111;
		end

		
initial begin

	reset=1;
	sda_in=0;
	
	#10;
	master_start=1'b1;
	reset=0;
	addr_in=7'h52;
	data_in=8'haa;
	read_write_bit = 0;

	#200
	data_in=7'h0;
	addr_in=7'hf0;
	rd_data = 8'h70;
	read_write_bit = 1;
	
	
	#200
	addr_in=7'h4c;
	data_in=8'h33;
	read_write_bit = 0;
	
	#200
	reset=1;
	
	#10
	master_start=1'b0;
	reset=0;
	data_in=7'h0;
	addr_in=7'h50;
	read_write_bit = 1;
	rd_data = 8'h9;
	
	#50
	master_start=1'b1;
	
	#205
	$stop;

	end


endmodule

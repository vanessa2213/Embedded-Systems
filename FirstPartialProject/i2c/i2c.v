module i2c(clk, reset, master_start, addr_in, data_in, read_write_bit, sda_in, sda, scl, data_read, reading);


/*********************inputs********************************************************************************/	
	input 		clk;  	      //master clock
	input 		reset;
	input 		master_start;  //master needs to raise this signal to initialize the data transfer
	input [6:0] addr_in;       //address that's being inserted into our module
	input [7:0] data_in; 	   //data that's being inserted into our module
	input 		read_write_bit;// 0 - write 	1 - read
	input 		sda_in;
/*********************outputs********************************************************************************/		
	output reg	 sda;  
	output wire  scl; 			  //i2c clock
	output reg 	 [7:0]data_read;
	output reg	 reading;
/*********************internal signals********************************************************************************/	
	reg [3:0] next_state;
	reg [3:0] count; //this will help us to keep track of the bits from the address so a loop can be created within
						  //the slave_address state
	reg enable_scl;
	reg [6:0] addr;
	reg [7:0] data; 	
	reg 		rwbit;
	
	//declaring the states of our fsm
	parameter idle 	  		= 4'b0000, //state 0
				 start 	  		= 4'b0001, //state 1
				 slave_address = 4'b0010, //state 2
				 w_ack			= 4'b0011, //state 3
				 w_ack2			= 4'b0100, //state 4
				 write_data		= 4'b0101, //state 5   if rwbit=0
				 read_data	  	= 4'b0110, //state 6	  if rwbit=1
				 stop 	  		= 4'b0111; //state 7
				 
	assign scl = (enable_scl==0) ? 1 : ~clk;
	//scl will follow the enable_scl signal, so it'd be a 1 whenever it's equal to 0
	//otherwise it'll look up to the value of clk and neglect it 
				 
always  @ (negedge clk) begin
	if (reset==1) begin
		enable_scl<=0;
	end	
	else begin
		if((next_state == idle)||(next_state == start)||(next_state == stop)) begin 
		//we don't need the i2c clock to pulse in this states since no data is being tranferred
			enable_scl<=0;
		end
		else begin
			enable_scl<=1;
		end
	end
end				 

				 
always @ (posedge clk) begin
	if(reset==1) begin
		next_state	<= idle;
		sda		 	<= 1'b1;
		count 	 	<= 4'b0;
		reading 	 	<= 1'b0;
		data_read 	<= 8'hz;
		end
	else begin
	
		case (next_state)
			idle:begin // state 0 initiliazing the data line 
				sda<=1;
				if(master_start==1) begin
					next_state <= start;
					addr <= addr_in;
					data <= data_in;
					rwbit <= read_write_bit;
					end
				else begin
					next_state <= idle;
				end
			end
			
			start:begin // state 1
				sda<=0;
				next_state<= slave_address;
				count <= 4'b0110; // initializing the value of count to 6 so it knows for the next 
										// next state that it needs to count from this value down to 0 
			end
			
			slave_address: begin // state 2
				sda<=addr[count];
				if(count==0) 
					next_state <= w_ack;
				else
					count <= (count-1);
			end
			
			
			w_ack: begin //state 3
				sda<=1;
				count<=4'b0111;
				 if(rwbit==0) begin
					next_state<=write_data;
				 end
				 else if (rwbit==1) begin
					reading = 1'b1;
					next_state<=read_data;	
				 end 
			end
			
			w_ack2: begin 		//state 4
				next_state<=stop;
			end
			
			write_data: begin //state 5
				sda<=data[count];
				if (count==0) //once we've transfer all bits from data we're ready to move on to the next state
					next_state<=w_ack2;
				else 
					count <= (count-1);
			end
			
		
			read_data: begin	//state 6
				if (count==0) begin //once we've transfer all bits from data we're ready to move on to the next state
					data_read <= {data[6:0], sda_in};
					next_state<=w_ack2;
				end
				else begin
					data[7:0] <= {data[6:0],sda_in};
					count <= (count-1);
				end
			end
							
			stop: begin		  //state 7
				sda<=1;
				next_state<=idle;
			end 
			
		endcase
	end 
end
endmodule
module mult_control(clk, reset_a, start, count, input_sel, shift_sel, state_out, done, clk_ena, sclr_n);

input clk, reset_a, start;

input [3:0] count;
output reg [3:0] input_sel; 
output reg [2:0] shift_sel;
output reg [3:0] state_out;
output reg       done, clk_ena, sclr_n;

reg [3:0] current_state, next_state;

parameter idle=4'd0, lsb=4'd1, N2=4'd2, N3=4'd3, N4=4'd4, N5=4'd5, N6=4'd6,msb=4'd7, calc_done=4'd8, err=4'd9;

always @ (posedge clk, posedge reset_a)
begin
	if(reset_a)
		current_state <= idle;
	else
		current_state <= next_state;

end

//combinatorial process to determine the next state in the FSM

always @ (start, count, current_state)
begin
	next_state <= current_state;
	case (current_state)
		idle:
			begin	
			if( start)
				next_state<= lsb;
			end
		lsb:
			begin
				if(count == 0  && start == 0)
					next_state <= N2;
				else
					next_state <= err;
			end
		N2:
			begin
				if(count == 4'0001  && start ==0 )
					next_state <= N2;
				else if  (count == 4'b0010  && start ==0)
					next_state <= N3;
				else
				 next_state <= err;
			end
		N3:
			begin
				if(count == 4'b0011  && start ==0 )
					next_state <= N3;
				else if(count == 4'b0100  && start ==0 )
					next_state <= N3;
				else if(count == 4'b0101  && start ==0 )
					next_state <= N4;
				else
				 next_state <= err;
			end
		N4:
			begin
				if(count == 4'b0110  && start ==0 )
					next_state <= N4;
				else if(count == 4'b0111  && start ==0 )
					next_state <= N4;
				else if(count == 4'b1000  && start ==0 )
					next_state <= N4;
				else if(count == 4'b1001  && start ==0 )
					next_state <= N5;
				else
				 next_state <= err;
			end
		N5:
			begin
				if(count == 4'b1010  && start ==0 )
					next_state <= N5;
				else if(count == 4'b1011  && start ==0 )
					next_state <= N5;
				else if(count == 4'b1100  && start ==0 )
					next_state <= N6;
				else
				 next_state <= err;
			end
		N6:
			begin
				if(count == 4'1101  && start ==0 )
					next_state <= N6;
				else if  (count == 4'b1110  && start ==0)
					next_state <= msb;
				else
				 next_state <= err;
			end
		msb:
			begin
				if(count == 4'b1111  && start == 0)
					next_state <= calc_done;
				else
					next_state <= err;
			end
		calc_done:
			begin
				if(!start )
					next_state <= idle;
				else
				 next_state <= err;
			end
		err:
			begin
				if(start )
					next_state <= lsb;
				else
				 next_state <= err;
			end
	endcase
end

//comb for outputs
always @(current_state, start, count)
begin
	//to avoid latches
	input_sel = 4'bXXXX;
	shift_sel = 3'bXXX;
	done      = 1'b0;
	clk_ena   = 1'b0;
	sclr_n   = 1'b1;
	//generate output logic
	case (current_state)
		idle:
			begin	
			if( start)
				begin
					clk_ena = 1;
					sclr_n  = 0;
				end
			end
		lsb:
			begin
				if(count == 0  && start == 0)
					begin
						input_sel =  4'b0000;
						shift_sel =  3'b000;
						clk_ena   =  1;
					end
			end
		N2:
			begin
				if(count == 4'0001  && start ==0 )
					begin
						input_sel =  4'b0100;
						shift_sel =  3'b001;
						clk_ena   =  1;
					end
				else if  (count == 4'b0010  && start ==0)
					begin
						input_sel =  4'b0001;
						shift_sel =  3'b001;
						clk_ena   =  1;
					end
			end
		N3:
			begin
				if(count == 4'b0011  && start ==0 )
					begin
						input_sel =  4'b1000;
						shift_sel =  3'b010;
						clk_ena   =  1;
					end
				else if(count == 4'b0100  && start ==0 )
					begin
						input_sel =  4'b0101;
						shift_sel =  3'b010;
						clk_ena   =  1;
					end
				else if(count == 4'b0101  && start ==0 )
					begin
						input_sel =  4'b0010;
						shift_sel =  3'b010;
						clk_ena   =  1;
					end
					
			end
		N4:
			begin
				if(count == 4'b0110  && start ==0 )
					begin
						input_sel =  4'b1100;
						shift_sel =  3'b011;
						clk_ena   =  1;
					end
				else if(count == 4'b0111  && start ==0 )
					begin
						input_sel =  4'b1001;
						shift_sel =  3'b011;
						clk_ena   =  1;
					end
				else if(count == 4'b1000  && start ==0 )
					begin
						input_sel =  4'b0110;
						shift_sel =  3'b011;
						clk_ena   =  1;
					end
				else if(count == 4'b1001  && start ==0 )
					begin
						input_sel =  4'b0011;
						shift_sel =  3'b011;
						clk_ena   =  1;
					end
			end
		N5:
			begin
				if(count == 4'b1010  && start ==0 )
					begin
						input_sel =  4'b1101;
						shift_sel =  3'b100;
						clk_ena   =  1;
					end
				else if(count == 4'b1011  && start ==0 )
					begin
						input_sel =  4'b1010;
						shift_sel =  3'b100;
						clk_ena   =  1;
					end
				else if(count == 4'b1100  && start ==0 )
					begin
						input_sel =  4'b0111;
						shift_sel =  3'b100;
						clk_ena   =  1;
					end
			end
		N6:
			begin
				if(count == 4'1101  && start ==0 )
					begin
						input_sel =  4'b1110;
						shift_sel =  3'b101;
						clk_ena   =  1;
					end
				else if  (count == 4'b1110  && start ==0)
					begin
						input_sel =  4'b1011;
						shift_sel =  3'b101;
						clk_ena   =  1;
					end
			end
		msb:
			begin
				if(count == 4'b1111  && start == 0)
					begin
						input_sel =  4'b1111;
						shift_sel =  3'b110;
						clk_ena   =  1;
					end
			end
		calc_done:
			begin
				if(!start )
					begin
						done   =  1;
					end
				else
					begin
						clk_ena   =  1;
						sclr_n   = 1'b0;
					end
			end
		err:
			begin
				if(start )
				begin
					clk_ena = 1;
					sclr_n  = 0;
				end;
			end
	endcase
	
end

always @ (current_state)
begin
	state_out = 4'b0000;
	case(current_state)
		idle: ;
		lsb: state_out = 4'b0001;
		N2: state_out  = 4'b0010;
		N2: state_out  = 4'b0011;
		N2: state_out  = 4'b0100;
		N2: state_out  = 4'b0101;
		N2: state_out  = 4'b0110;
		msb: state_out = 4'b0111;
		calc_done: state_out = 4'b1000;
		err: state_out = 4'b1001;
	endcase
end

endmodule 
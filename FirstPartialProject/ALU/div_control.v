module div_control (clk, goreq, start, count_done, reset_a,count, done, sel_mux_in, sh_cnt1, sh_cnt2, sclr_n, clk_ena, mux1b, en_count, zero,en_sum, en_rest,clk_ena_sum, clk_ena_rest);

input goreq, start, count_done, reset_a, clk;
input [3:0] count;

output reg done, sel_mux_in, sh_cnt1, sh_cnt2, sclr_n, clk_ena, mux1b, en_count,zero, en_sum, en_rest, clk_ena_sum, clk_ena_rest;



reg [3:0] current_state, next_state;

parameter idle=4'd0, c1=4'd1, c2=4'd2, c3=4'd3, rest_0=4'd4, rest=4'd5, sum=4'd6,calc_done=4'd7, err=4'd8;

always @ (posedge clk, posedge reset_a)
begin
	if(reset_a)
		current_state <= idle;
	else
		current_state <= next_state;

end

//combinatorial process to determine the next state in the FSM

always @ (*)
begin
	next_state <= current_state;
	case (current_state)
		idle:
			begin	
			if( start)
				next_state <= c1;
			end
		c1:
			begin
			if(goreq && !start)
				next_state <= c2;
			else
				next_state <= err;
			end
		c2:
			begin
			if(count_done && !start)
				next_state <= c3;
			else
				next_state <= err;
			end
		c3:
			begin
			if(!goreq && !start)
				next_state <= rest_0;
			else if(goreq && !start)
				next_state <= rest;
			else
				next_state <= err;
			end	
		rest_0:
			begin
			if(!start)
				next_state <= sum;
			else
				next_state <= err;
			end
		rest:
			begin
			if(!start)
				next_state <= sum;
			else
				next_state <= err;
			end
		sum:
			begin
			if(count == 4'd15 && !start)
				next_state <= calc_done;
			else if(count != 4'd15 && !start)
				next_state <= c3;
			else
				next_state <= err;
			end
		calc_done:
			begin
				if(!start)
					next_state <= idle;
				else
					next_state <= err;
			end
		err:
			begin
				if(start )
					next_state <= c1;
				else
				 next_state <= err;
			end
	endcase
		

end

//comb for outputs
always @(*)
begin
	done     = 0;
	clk_ena  = 0;
	sclr_n   = 1;
	en_count = 0;
	en_sum = 0;
	en_rest = 0;
	zero		  = 1'b1;
	sel_mux_in = 1'b1;
	mux1b		  = 1'b0;
	sh_cnt1    = 1'b0;
	sh_cnt2    = 1'b0;
	clk_ena_rest = 0;
	clk_ena_sum = 0;
	
	
	case (current_state)
		idle:begin  
		end
		c1:
			begin
			sclr_n   = 0;
			clk_ena_rest = 1;
			clk_ena_sum = 1;
			clk_ena  = 1;
			zero		  = 1'b1;
			sel_mux_in = 1'b0;
			mux1b		  = 1'b0;
			sh_cnt1    = 1'b0;
			sh_cnt2    = 1'b0;
			end
		c2:
			begin
			zero = 1;
			mux1b		  = 1'b0;
			sh_cnt1    = 1'b0;
			sh_cnt2    = 1'b0;
			end
		c3:
			begin
			zero = 1;
			mux1b		  = 1'b0;
			sh_cnt1    = 1'b0;
			sh_cnt2    = 1'b0;
			end	
		rest_0:
			begin
			en_count = 0;
			en_rest = 1;
			zero = 1;
			clk_ena_rest  = 1;
			mux1b		  = 1'b0;
			sh_cnt1    = 1'b1;
			sh_cnt2    = 1'b1;
			clk_ena  = 1;
			end
		rest:
			begin
			en_count = 0;
			en_rest = 1;
			zero = 0;
			clk_ena_rest  = 1;
			mux1b		  = 1'b1;
			sh_cnt1    = 1'b1;
			sh_cnt2    = 1'b1;
			clk_ena  = 1;
			end
		sum:
			begin
			en_count = 1;
			clk_ena_sum  = 1;
			en_sum = 1;
			zero		  = 1'b1;
			mux1b		  = 1'b0;
			end
		calc_done:
			begin
				done     = 1;
				clk_ena  = 1;
				zero		  = 1'b1;
				mux1b		  = 1'b0;
				sh_cnt1    = 1'b0;
				sh_cnt2    = 1'b1;
			end
		err:begin  end
	endcase
end


endmodule 
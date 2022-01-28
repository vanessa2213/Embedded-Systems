module alu_control(clk, reset_a,start,done_in, done_out, state_out);

input clk, reset_a, start, done_in;
output reg done_out;
output reg [1:0] state_out;

reg [1:0] current_state, next_state;

parameter inicio=2'd0, calc=2'd1, fin=2'd3;

always @(posedge clk,posedge reset_a)begin
	if(reset_a)
		current_state <= inicio;
	else
		current_state <= next_state;
end

always @(current_state, start,done_in)begin
	next_state <= current_state;
	
	case(current_state)
		inicio:begin
			if(start)
				next_state<=calc;
		end
		calc:begin
			if(done_in)
				next_state<=fin;
		end
		fin:begin
			if(!start)
				next_state<=inicio;
		end
	endcase
end

always @(current_state, start, done_in)begin
	done_out = 1'b0;

	case(current_state)
		inicio:begin
			if(start)
				done_out = 1'b0;
		end
		calc:begin
			if(done_in)
				done_out = 1'b1;

		end
		fin:begin
			if(!start)
				done_out = 1'b1;
		end
	endcase
end

always @ (current_state)
begin
	state_out = 2'b00;
	case(current_state)
		inicio: ;
		calc: state_out = 2'b01;
		fin: state_out = 2'b10;
	endcase
end
				
endmodule
module alu(dataa, datab, start, reset_a, clk, opcode, state, out, carry_flag, zero_flag, done_flag);

	input [15:0] dataa, datab;
	input [3:0] opcode;
	input start,  reset_a, clk, state;
	output reg [31:0] out;
	output reg carry_flag, done_flag;
	output zero_flag;
	
	parameter ADD 	= 4'b0000;
	parameter SUB 	= 4'b0001;
	parameter MULT = 4'b0010;
	parameter DIV 	= 4'b0011;
	parameter AND 	= 4'b0100;
	parameter OR 	= 4'b0101;
	parameter NAND = 4'b0110;
	parameter NOR  = 4'b0111;
	parameter XOR 	= 4'b1000;
	parameter SL   = 4'b1001;
	parameter SR   = 4'b1010;
	parameter CSL  = 4'b1011;
	parameter CSR  = 4'b1100;
	parameter GREATER = 4'b1101;
	parameter SMALLER = 4'b1110;
	parameter EQUAL   = 4'b1111;
	
	wire [31:0] product_out;
	wire [15:0] division_out;
	wire product_done, division_done;
	
	assign zero_flag = (out == 32'd0)? 1'b1:1'b0;
	
	multi16x16 u1(.dataa(dataa), .datab(datab), .start(start), .reset_a(reset_a), .clk(clk), .product16x16_out(product_out), .done_flag(product_done));
	divider u2(.dividen(dataa), .divisor(datab), .start(start), .reset_a(reset_a), .clk(clk), .quotient(division_out), .done(division_done));
	
	always@(opcode, dataa, datab, out, carry_flag, done_flag, state, product_done, division_done)begin
		if(state == 2'b01)begin
			case(opcode)
				ADD:begin
					out = dataa + datab;
					carry_flag = out[16];
					done_flag = 1'b1;
				end
				SUB:begin
					out = dataa - datab;
					carry_flag = out[16];
					done_flag = 1'b1;
				end
				MULT:begin
					out = product_out;
					done_flag = product_done;
				end
				DIV:begin
					out = division_out;
					done_flag = division_done;
				end
				AND: begin
					out = dataa & datab;
					done_flag = 1'b1;
				end
				OR:begin
					out = dataa | datab;
					done_flag = 1'b1;
				end
				NAND:begin
					out = ~(dataa & datab);
					done_flag = 1'b1;
				end
				NOR:begin
					out = ~(dataa | datab);
					done_flag = 1'b1;
				end
				XOR:begin
					out = dataa ^ datab;
					done_flag = 1'b1;
				end
				SL:begin
					out = dataa << 1;
					done_flag = 1'b1;
				end
				SR:begin
					out = dataa >> 1;
					done_flag = 1'b1;
				end
				CSL:begin
					out = {dataa[14:0], dataa[15]};
					done_flag = 1'b1;
				end
				CSR:begin
					out = {dataa[0], dataa[15:1]};
					done_flag = 1'b1;
				end
				GREATER:begin
					out = (dataa > datab)?16'd1:16'd0;
					done_flag = 1'b1;
				end
				SMALLER:begin
					out = (dataa < datab)?16'd1:16'd0;
					done_flag = 1'b1;
				end
				EQUAL:begin
					out = (dataa == datab)?16'd1:16'd0;
					done_flag = 1'b1;
				end
				default:begin
					out = dataa + datab;
					done_flag = 1'b0;
				end
			endcase
		end
		else begin
			out = 32'd0;
			carry_flag = 1'b0;
			done_flag = 1'b0;
		end
	end
		
	
				
endmodule

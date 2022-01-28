module adder (dataa, datab, sum);

input [31:0] dataa, datab;
output [31:0] sum; 

assign sum = dataa + datab;

endmodule 
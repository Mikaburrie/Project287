`timescale 1 ps / 1 ps

module tb_processor;

	reg clk;
	reg rst;
	
	reg [31:0] in;
	wire [31:0] out;
	
	
	processor PROC(clk, rst, in, out);
	
	// Clock cycle every 20 ps (50MHz)
	always #10 clk = ~clk;
	
	initial begin
	
		clk <= 1;
		rst <= 0;
		in <= 32'b00000000000000000000000000000000;
		
		#40
		
		rst <= 1;
		
		#1000
		
		in <= 21'b000000000000100000010;
		
		#5000;
		
		in <= 21'b000000000000000000010;
		
		#1000 $finish;
		
	end

endmodule

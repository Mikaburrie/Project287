`timescale 1 ps / 1 ps

module tb_processor;

	reg clk;
	reg rst;
	
	reg [31:0] in;
	wire [31:0] out;
	
	
	processor proc(clk, rst, in, out);
	
	// Flips clk every 40 ps (25 MHz)
	always #40 clk = ~clk;
	
	initial begin
	
		clk <= 1;
		rst <= 0;
		in <= 32'd31;
		
		#40
		
		rst <= 1;
		
		
		#3000;
		
		rst <= 0;
		
		#100
		
		rst <= 1;
		
		#5000 $finish;
		
	end

endmodule

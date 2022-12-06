`timescale 1 ps / 1 ps

module tb_processor;

	reg clk;
	reg rst;
	
	reg [31:0] in;
	wire [31:0] out;
	
	
	processor proc(clk, rst, in, out);
	
	// Flips clk every 20 ps
	always #20 clk = ~clk;
	
	initial begin
	
		clk <= 1;
		rst <= 0;
		in <= 32'd2;
		
		#40
		
		rst <= 1;
		
		
		#400 $finish;
		
	end

endmodule

`timescale 1 ps / 1 ps

module tb_project287;

	reg clk;
	reg rst;
	
	reg [20:0] in;
	wire [55:0] segs;
	
	
	Project287 PROJ(clk, rst, in, segs);
	
	// Clock cycle every 20 ps (50MHz)
	always #10 clk = ~clk;
	
	initial begin
	
		clk <= 1;
		rst <= 0;
		in <= 32'b00000000000000010111;
		
		#40
		
		rst <= 1;
		
		#3000;
		
		rst <= 0;
		
		#100
		
		rst <= 1;
		
		#5000 $finish;
		
	end

endmodule

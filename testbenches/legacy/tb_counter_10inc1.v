module tb_counter_10inc1;

	reg clk;
	reg rst;
	wire [9:0] val;
	
	counter_10inc1 counter(clk, rst, val);
	
	// Flips clk every 20 ns -> 40 ns clock period ~ 25 MHz
	always #20 clk = ~clk;
	
	initial begin
	
		clk <= 1;
		rst <= 0;
		
		#70 rst <= 1;
		#60000 rst <= 0;
		
		#60000 $finish;
		
	end

endmodule

module tb_double_counter_800x525;

	reg clk;
	reg rst;
	wire [9:0] val_x;
	wire [9:0] val_y;
	
	double_counter_800x525 counter(clk, rst, val_x, val_y);
	
	// Flips clk every 20 ns -> 40 ns clock period ~ 25 MHz
	always #20 clk = ~clk;
	
	initial begin
	
		clk <= 1;
		rst <= 0;
		
		#40 rst <= 1;
		#30000000 rst <= 0;
		
		#100 $finish;
		
	end

endmodule

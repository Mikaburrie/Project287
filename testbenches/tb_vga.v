module tb_vga;

	reg clk;
	reg rst;
	wire [25:0] vga_output_data;
	wire [9:0] x, y;
	
	vga disp(clk, rst, vga_output_data, x, y);
	
	// Flips clk every 20 ns -> 40 ns clock period ~ 25 MHz
	always #20 clk = ~clk;
	
	initial begin
	
		clk <= 1;
		rst <= 0;
		
		#40 rst <= 1;
		#40000000 rst <= 0;
		
		#100 $finish;
		
	end

endmodule

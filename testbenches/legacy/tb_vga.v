module tb_vga;

	reg clk;
	reg rst;
	reg [7:0] r, g, b;
	wire [9:0] x, y;
	wire [28:0] vga_output_data;
	
	
	vga disp(clk, rst, r, g, b, x, y, vga_output_data);
	
	// Flips clk every 20 ns -> 40 ns clock period ~ 25 MHz
	always #20 clk = ~clk;
	
	initial begin
	
		clk <= 1;
		rst <= 0;
		r <= 0;
		g <= 0;
		b <= 0;
		
		#40 rst <= 1;
		#40000000 rst <= 0;
		
		#100 $finish;
		
	end

endmodule

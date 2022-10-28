module Project287(input clk, input rst, output [25:0]vga_output_data);
	
	wire a, b;
	
	vga disp(clk, rst, vga_output_data, a, b);

endmodule

module Project287(input clk, input rst, output [9:0]val_x, output [9:0]val_y);
	
	double_counter_800x525 pixels(clk, rst, val_x, val_y);

endmodule

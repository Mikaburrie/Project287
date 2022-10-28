module vga(clk, rst, vga_output_data, x, y);

	input clk, rst;
	output reg [25:0]vga_output_data;
	
	reg clk_25M;
	output wire [9:0] x, y;
	double_counter_800x525 counter(clk_25M, rst, x, y);
	
	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin
			clk_25M <= 0;
		end else begin
			clk_25M <= ~clk_25M;
		end
	
	end
	
	always @(posedge clk_25M or negedge rst) begin
		if (rst == 1'b0) begin
			vga_output_data[23:0] <= 24'b111111111111111111111111;
			vga_output_data[24] <= 1;
			vga_output_data[25] <= 1;
		end else begin
		
			if (x == 10'd655)
				vga_output_data[24] <= 0;
			else if (x == 10'd751)
				vga_output_data[24] <= 1;
			
			if (y == 10'd489 & x == 10'd799)
				vga_output_data[25] <= 0;
			else if (y == 10'd491 & x == 10'd799)
				vga_output_data[25] <= 1;
				
		end
	end



endmodule

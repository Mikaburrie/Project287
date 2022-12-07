module vga(clk, rst, r, g, b, x, y, vga_output_data);

	input clk, rst;
	input [7:0] r, g, b;
	output reg [28:0] vga_output_data;
	output wire [9:0] x, y;
	
	reg clk_25M;
	double_counter_800x525 counter(clk_25M, rst, x, y);
	
	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin
		
			clk_25M <= 0;
			vga_output_data[28] <= 0;
			
		end else begin
		
			clk_25M <= ~clk_25M;
			vga_output_data[28] <= ~clk_25M;
			
		end
	
	end
	
	
	wire x_blank, x_sync, y_blank, y_sync;
	reg x_sync_delay, y_sync_delay;
	
	assign x_blank = (10'd639 < x);
	assign x_sync = (10'd655 < x & x < 10'd752);
	assign y_blank = (10'd479 < y);
	assign y_sync = (10'd489 < y & y < 10'd492);
	
	always @(posedge clk_25M or negedge rst) begin
	
		if (rst == 1'b0) begin
		
			vga_output_data[23:0] <= 24'h0;
			vga_output_data[24] <= 1;
			vga_output_data[25] <= 1;
			vga_output_data[27:26] <= 0;
			x_sync_delay <= 0;
			y_sync_delay <= 0;
			
		end else begin
		
			vga_output_data[23:0] <= {b[7:0], g[7:0], r[7:0]};
		
			x_sync_delay <= x_sync;
			y_sync_delay <= y_sync;
			vga_output_data[24] <= ~x_sync_delay;
			vga_output_data[25] <= ~y_sync_delay;
			
			vga_output_data[26] <= ~(x_blank | y_blank);
			vga_output_data[27] <= ~(x_sync | y_sync);
			
		end
		
	end

endmodule

module Project287(clk, rst, vga_output_data);
	
	input clk, rst;
	output [28:0] vga_output_data;
	
	reg [7:0] r, g, b;
	wire [9:0] x, y;
	
	vga disp(clk, rst, r, g, b, x, y, vga_output_data);
	
	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin
			
			r <= 0;
			g <= 0;
			b <= 0;
			
		end else begin
		
			r <= x[9:2];
			g <= y[9:2];
			b <= 0;
		
		end
	
	end

endmodule

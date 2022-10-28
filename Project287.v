module Project287(clk, rst, vga_output_data);
	
	input clk, rst;
	output [28:0] vga_output_data;
	
	reg [7:0] r, g, b;
	wire [9:0] x, y;
	
	reg [8:0] shift;
	
	vga disp(clk, rst, r, g, b, x, y, vga_output_data);
	
	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin
			
			r <= 0;
			g <= 0;
			b <= 0;
			shift <= 8'b00000001;
			
		end else begin
		
			r <= x[7:0];
			g <= y[9:2];
			b <= shift;
			shift <= {shift[6:0], shift[7] ^ shift[6]};
		
		end
	
	end

endmodule

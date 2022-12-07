module double_counter_800x525(clk, rst, x, y);

	input clk;
	input rst;
	output reg [9:0]x;
	output reg [9:0]y;
	
	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin
			// reset x and y
			x <= 0;
			y <= 0;
		end else begin
			
			if (x == 10'd799) begin
				// reset x if 799
				x <= 0;
				
				if (y == 10'd524) begin
					// reset y if 524
					y <= 0;
					
				end else begin
					// inc y if < 524
					y <= y + 10'd1;
					
				end
				
			end else begin
				// inc x if < 799
				x <= x + 10'd1;
				
			end
			
		end
	
	end

endmodule

module counter_10inc1(input clk, rst, output reg [9:0]val);

	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin
			val <= 9'b0;
		end else begin
			val <= val + 1'b1;
		end
	
	end
	
endmodule

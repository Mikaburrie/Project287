module program_counter(clk, rst, counter, offset, set_counter, next);

	input clk, rst, set_counter;
	input [31:0] offset;
	
	output reg [31:0] counter, next;
	
	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin
		
			counter <= 0;
		
		end else begin
		
			if (offset != 0 | set_counter == 1'b1) begin
			
				counter <= next;
				
			end
		
		end
	
	end
	
	
	always @(*) begin
	
		if (set_counter == 1'b1)
			next = offset;
		else
			next = counter + offset;
		
	end
	
endmodule

module debouncer #(parameter LIMIT=20'd999999) (clk, rst, in, out);

	input clk, rst, in;
	output reg out;
	
	reg [19:0] count;
	
	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin
		
			out <= 0;
			count <= 0;
		
		end else begin
	
			if (in == out)
				count <= 0;
				
			else begin
			
				if (count == LIMIT) begin
					
					count <= 0;
					out <= in;
				
				end else
					count <= count + 1'b1;
			
			end
		
		end
	
	end

endmodule

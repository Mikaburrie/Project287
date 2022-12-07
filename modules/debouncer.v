module debouncer #(parameter LIMIT=20'd999999) (clk, in, out);

	input clk, in;
	output reg out;
	
	reg [19:0] count;
	
	always @(posedge clk) begin
	
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

endmodule

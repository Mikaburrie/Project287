module alu(clk, rst, in_a, in_b, wren_a, wren_b, func, result);

	input clk, rst, wren_a, wren_b;
	input [31:0] in_a, in_b;
	input [3:0] func;
	output reg [31:0] result;
	
	reg [31:0] a, b;
	
	always @(posedge clk or negedge rst) begin
		
		if (rst == 1'b0) begin
		
			a <= 0;
			b <= 0;
			
		end else begin
		
			if (wren_a == 1'b1)
				a <= in_a;
			if (wren_b == 1'b1)
				b <= in_b;
				
		end
		
	end

	always @(*) begin
	
		if (rst == 1'b0)
			result = 0;
		else begin
		
			case (func)
				// Add
				4'b0000: result = a + b;
				
				// Sub
				4'b1000: result = a - b;
				
				// Shift logical left
				4'b0001,
				4'b1001: result = a << b[4:0];
				
				// Less than signed
				4'b0010,
				4'b1010: if (a[31] == b[31])
								result = a < b;
							else
								result = a[31];
				
				// Less than unsigned
				4'b0011,
				4'b1011: result = a < b;
				
				// XOR
				4'b0100,
				4'b1100: result = a ^ b;
				
				// Shift right logical (fill 0's)
				4'b0101: result = a >> b[4:0];
				
				// Shift right arithmetic (1's)
				4'b1101: result = a >>> b[4:0];
				
				// OR
				4'b0110,
				4'b1110: result = a | b;
				
				// AND
				4'b0111,
				4'b1111: result = a & b;
				
				default: result = 0;
			endcase
		
		end
	
	end

endmodule

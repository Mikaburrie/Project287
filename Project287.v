module Project287(clk, rst, out);
	
	input clk, rst;
	
	reg [31:0] in;
	output wire [31:0] out;
	
	processor proc(clk, rst, in, out);
	
	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin
		
			in <= 3;
		
		end else begin
	
		end
		
	end

endmodule

module Project287(clk, rst_bc, in_bc, segs);
	
	input clk, rst_bc;
	input [20:0] in_bc;
	output [55:0] segs;
	
	wire rst;
	debouncer RST(clk, rst_bc, rst_bc, rst);
	
	wire [20:0] in;
	genvar i;
	generate
	
		for (i = 0; i < 21; i = i + 1) begin : IN_DEBOUNCING
		
			debouncer IN(clk, rst_bc, in_bc[i], in[i]);
		
		end
	
	endgenerate
	
	wire [31:0] out;
	
	reg [31:0] clk_counter;
	reg clk_var;
	reg rst_prev;
	
	wire [4:0] clk_speed;
	assign clk_speed = in[16:12];
	
	wire [4:0] radix;
	assign radix = in[20:17] + 1'b1;
	
	wire [31:0] data_in;
	assign data_in = {20'b0, ~in[11:8], in[7:0]};
	
	
	
	
	processor PROC(clk_var, rst, data_in, out);
	
	x8_seven_segment_signed DISP(out, radix, segs);
	
	always @(posedge clk or negedge rst) begin
		
		if (rst == 1'b0) begin
		
			rst_prev <= 0;
			clk_var <= 0;
			clk_counter <= 0;
		
		end else begin
		
			if (clk_counter >= (32'b1 << clk_speed)) begin
			
				clk_counter <= 0;
				
				if (rst_prev)
					clk_var <= ~clk_var;
				else
					rst_prev <= 1;
			
			end else
				clk_counter <= clk_counter + 1'b1;
		
		
		end
		
	end

endmodule

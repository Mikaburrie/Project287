module tb_controller;

	reg clk;
	reg rst;
	reg [31:0] a, b;
	wire [2:0] opcode;
	wire func;
	wire [31:0] result;
	
	
	alu alualualu(clk, rst, a, b, opcode, func, result);
	
	// Flips clk every 20 ps
	always #20 clk = ~clk;
	
	initial begin
	
		clk <= 1;
		rst <= 0;
		a <= 0;
		b <= 0;
		opcode <= 0;
		func <= 0;
		
		
		
		
		#100 $finish;
		
	end

endmodule

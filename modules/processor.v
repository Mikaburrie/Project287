module processor(clk, rst, in, out);

	parameter EN_WIDTH = 3,
				 EN_OFF = 3'd0,
				 EN_REG = 3'd1,
				 EN_ALU = 3'd2,
				 EN_MEM = 3'd3,
				 EN_IMM = 3'd4,
				 EN_CTR = 3'd5;
	
	parameter WREN_CT = 5,
				 WREN_REG = 0,
				 WREN_A = 1,
				 WREN_B = 2,
				 WREN_MEM = 3,
				 WREN_CTR = 4;

	input clk, rst;
	input [31:0] in;
	output reg [31:0] out;
	
	wire [31:0] instruction;
	wire [EN_WIDTH - 1:0] en;
	wire [WREN_CT - 1:0] wren;
	wire [7:0] address;
	reg [7:0] prev_address = 8'd0;
	wire [31:0] immediate;
	wire [3:0] func;
	wire [31:0] pc_advance, pc_next;
	wire [31:0] counter;
	
	wire [31:0] reg_out, alu_out, mem_out;
	reg [31:0] bus;

	wire con_rst;
	controller CON(clk, rst, instruction, bus, en, wren, address, immediate, func, pc_advance);
	
	wire wren_reg;
	assign wren_reg = wren[WREN_REG] & (address != 0); // Prohibit writing to register x0
	registers REGS(address[4:0], clk, bus, wren_reg, reg_out);
	
	alu ALU(clk, rst, bus, bus, wren[WREN_A], wren[WREN_B], func, alu_out);
	
	program_counter PC(clk, rst, counter, pc_advance, wren[WREN_CTR], pc_next);
	
	memory MEM(address, pc_next[9:2], clk, bus, 32'b0, wren[WREN_MEM], 1'b0, mem_out, instruction);
	
	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin
		
			out <= 0;
			prev_address <= 0;
		
		end else begin
		
			prev_address <= address;
		
			if (address == 8'd255 & wren[WREN_MEM])
				out <= bus;
		
		end
	
	end
	
	
	always @(*) begin
	
		case(en)
		
			EN_REG: bus = reg_out;
			EN_ALU: bus = alu_out;
			EN_MEM:
				if (prev_address == 8'd255)
					bus = in;
				else
					bus = mem_out;
			EN_IMM: bus = immediate;
			EN_CTR: bus = counter + 4;
			default: bus = 0;
		
		endcase
	
	end

endmodule

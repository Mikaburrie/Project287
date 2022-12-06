module controller(clk, rst, instruction, bus, en, wren, addr_reg, immediate, alu_func, next);
	
	parameter EN_WIDTH = 3,
				 EN_OFF = 3'd0,
				 EN_REG = 3'd1,
				 EN_ALU = 3'd2,
				 EN_MEM = 3'd3,
				 EN_IMM = 3'd4,
				 EN_CTR = 3'd5;
	
	parameter WREN_CT = 5,
				 WREN_REG = 5'b00001,
				 WREN_A   = 5'b00010,
				 WREN_B   = 5'b00100,
				 WREN_MEM = 5'b01000,
				 WREN_CTR = 5'b10000;
	
	input clk, rst;
	input [31:0] instruction, bus;
	reg [31:0] bus_prev;
	
	output reg [EN_WIDTH - 1:0] en;
	output reg [WREN_CT - 1:0] wren;
	output reg [7:0] addr_reg;
	output reg [31:0] immediate;
	output reg [3:0] alu_func;
	output reg [31:0] next;
	
	reg [2:0] state;
	
	wire [6:0] opcode;
	assign opcode = instruction[6:0];
	
	wire [3:0] sign_ext;
	assign sign_ext = {instruction[31], instruction[31], instruction[31], instruction[31]};
	
	wire [31:0] i_type_immediate;
	assign i_type_immediate = {sign_ext, sign_ext, sign_ext, sign_ext, sign_ext, instruction[31:20]};
	
	wire [31:0] s_type_immediate;
	assign s_type_immediate = {sign_ext, sign_ext, sign_ext, sign_ext, sign_ext, instruction[31:25], instruction[11:7]};
	
	wire [31:0] b_type_immediate;
	assign b_type_immediate = {sign_ext, sign_ext, sign_ext, sign_ext, sign_ext, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
	
	wire [31:0] u_type_immediate;
	assign u_type_immediate = {instruction[31:12], 12'b0};
	
	wire [31:0] j_type_immediate;
	assign j_type_immediate = {sign_ext, sign_ext, sign_ext, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
	
	wire [4:0] rd;
	assign rd = instruction[11:7];
	
	wire [4:0] rs1;
	assign rs1 = instruction[19:15];
	
	wire [4:0] rs2;
	assign rs2 = instruction[24:20];
	
	wire [3:0] func4;
	assign func4 = {instruction[30], instruction[14:12]};
	
	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin
			
			state <= 0;
			bus_prev <= 0;
			
		end else begin
		
			bus_prev <= bus;
		
			case ({state, opcode})
			
				10'b0000110111, //LUI s=0
				10'b1000010111, //AUIPC s=4
				10'b0001101111, //JAL s=0
				10'b0111100111, //JALR s=3
				10'b0111100011, //Branch s=3
				10'b0110000011, //Load s=3
				10'b0110100011, //Store s=3
				10'b0100010011, //Alu w/ immediates s=2
				10'b0110110011: //Alu w/ reg s=3
			//	7'b0001111: ;//FENCE
			//	7'b1110011: ;//ECALL / EBREAK
					state <= 0;
				default:
					state <= state + 1'b1;
			
			endcase
		
		end
	
	end
	
	always @(*) begin
	
		if (rst == 1'b0) begin
		
			en = EN_OFF;
			wren = 0;
			addr_reg = 0;
			immediate = 0;
			alu_func = 0;
			next = 0;
		
		end else begin
	
			case (opcode)
			
				7'b0110111: begin //LUI
					case (state)
						4'd0: begin // Load immediate into rd
							en = EN_IMM;
							wren = WREN_REG;
							addr_reg = rd;
							immediate = u_type_immediate;
							alu_func = 0;
							next = 4;
						end
						default: begin
							en = EN_OFF;
							wren = 0;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
					endcase
				end
				7'b0010111: begin //AUIPC
					case (state)
						4'd0: begin // Load counter into a
							en = EN_CTR;
							wren = WREN_A;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
						4'd1: begin // Load immediate into b
							en = EN_IMM;
							wren = WREN_B;
							addr_reg = 0;
							immediate = u_type_immediate;
							alu_func = 0;
							next = 0;
						end
						4'd2: begin // Move result into a
							en = EN_ALU;
							wren = WREN_A;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
						4'd3: begin // Move 4 into b
							en = EN_IMM;
							wren = WREN_B;
							addr_reg = 0;
							immediate = 4;
							alu_func = 0;
							next = 0;
						end
						4'd4: begin // Store subtraction in rd
							en = EN_ALU;
							wren = WREN_REG;
							addr_reg = rd;
							immediate = 0;
							alu_func = 4'b1000;
							next = 4;
						end
						default: begin
							en = EN_OFF;
							wren = 0;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
					endcase
				end
				7'b1101111: begin //JAL
					case (state)
						4'd0: begin // Store counter in rd
							en = EN_CTR;
							wren = WREN_REG;
							addr_reg = rd;
							immediate = 0;
							alu_func = 0;
							next = j_type_immediate;
						end
						default: begin
							en = EN_OFF;
							wren = 0;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
					endcase
				end
				7'b1100111: begin //JALR
					case (state)
						4'd0: begin // Load immediate into alu's b, get rs1 from registers
							en = EN_IMM;
							wren = WREN_B;
							addr_reg = rs1;
							immediate = i_type_immediate;
							alu_func = 0;
							next = 0;
						end
						4'd1: begin // Load register into alu's a
							en = EN_REG;
							wren = WREN_A;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
						4'd2: begin // Store counter in rd
							en = EN_CTR;
							wren = WREN_REG;
							addr_reg = rd;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
						4'd3: begin // Add alu to program counter
							en = EN_ALU;
							wren = WREN_CTR;
							addr_reg = rd;
							immediate = 0;
							alu_func = 0;
							next = bus;
						end
						default: begin
							en = EN_OFF;
							wren = 0;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
					endcase
				end
				7'b1100011: begin //Branch
					case (state)
						4'd0: begin // Load rs1 from reg
							en = 0;
							wren = 0;
							addr_reg = rs1;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
						4'd1: begin // Load rs1 into a, get rs2 from reg
							en = EN_REG;
							wren = WREN_A;
							addr_reg = rs2;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
						4'd2: begin // Load rs2 into b, get rs2 from reg
							en = EN_REG;
							wren = WREN_B;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
						4'd3: begin // Do the comparison
							en = EN_ALU;
							wren = 0;
							addr_reg = 0;
							immediate = 0;
							alu_func = {~func4[2], 1'b0, func4[2], func4[1]};
							if ((func4[0] == 1) ^ (bus == func4[2])) // Condition is true
								next = b_type_immediate;
							else
								next = 4;
						end
						default: begin
							en = EN_OFF;
							wren = 0;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
					endcase
				end
				7'b0000011: begin //Load
					case (state)
						4'd0: begin // Load immediate into alu's b, get rs1 from registers
							en = EN_IMM;
							wren = WREN_B;
							addr_reg = rs1;
							immediate = i_type_immediate;
							alu_func = 0;
							next = 0;
						end
						4'd1: begin // Load register into alu's a
							en = EN_REG;
							wren = WREN_A;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
						4'd2: begin // Read alu result as address in memory
							en = EN_ALU;
							wren = 0;
							addr_reg = bus[7:0];
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
						4'd3: begin // Store memory contents in rd
							en = EN_MEM;
							wren = WREN_REG;
							addr_reg = rd;
							immediate = 0;
							alu_func = 0;
							next = 4;
						end
						default: begin
							en = EN_OFF;
							wren = 0;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
					endcase
				end
				7'b0100011: begin //Store
				case (state)
						4'd0: begin // Load immediate into alu's b, get rs1 from registers
							en = EN_IMM;
							wren = WREN_B;
							addr_reg = rs1;
							immediate = s_type_immediate;
							alu_func = 0;
							next = 0;
						end
						4'd1: begin // Load register into alu's a
							en = EN_REG;
							wren = WREN_A;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
						4'd2: begin // Read alu result to bus, load rs2 from registers
							en = EN_ALU;
							wren = 0;
							addr_reg = rs2;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
						4'd3: begin // Store register contents in memory
							en = EN_REG;
							wren = WREN_MEM;
							addr_reg = bus_prev[7:0];
							immediate = 0;
							alu_func = 0;
							next = 4;
						end
						default: begin
							en = EN_OFF;
							wren = 0;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
					endcase
				end
				7'b0010011: begin //Alu w/ immediates
					case (state)
						4'd0: begin // Load immediate into alu's b, get rs1 from registers
							en = EN_IMM;
							wren = WREN_B;
							addr_reg = rs1;
							immediate = i_type_immediate;
							alu_func = func4;
							next = 0;
						end
						4'd1: begin // Load register into alu's a
							en = EN_REG;
							wren = WREN_A;
							addr_reg = 0;
							immediate = 0;
							alu_func = func4;
							next = 0;
						end
						4'd2: begin // Store alu result in register
							en = EN_ALU;
							wren = WREN_REG;
							addr_reg = rd;
							immediate = 0;
							alu_func = func4;
							next = 4;
						end
						default: begin
							en = EN_OFF;
							wren = 0;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
					endcase
				end
				7'b0110011: begin//Alu w/ reg
					case (state)
						4'd0: begin // Get rs1 from registers
							en = 0;
							wren = 0;
							addr_reg = rs1;
							immediate = 0;
							alu_func = func4;
							next = 0;
						end
						4'd1: begin // Load rs1 into a, get rs2 from registers
							en = EN_REG;
							wren = WREN_A;
							addr_reg = rs2;
							immediate = 0;
							alu_func = func4;
							next = 0;
						end
						4'd2: begin // Load rs2 into b
							en = EN_REG;
							wren = WREN_B;
							addr_reg = 0;
							immediate = 0;
							alu_func = func4;
							next = 0;
						end
						4'd3: begin // Store result in rd
							en = EN_ALU;
							wren = WREN_REG;
							addr_reg = rd;
							immediate = 0;
							alu_func = func4;
							next = 4;
						end
						default: begin
							en = EN_OFF;
							wren = 0;
							addr_reg = 0;
							immediate = 0;
							alu_func = 0;
							next = 0;
						end
					endcase
				end
			//	7'b0001111: ;//FENCE
			//	7'b1110011: ;//ECALL / EBREAK
				default: begin
					en = EN_OFF;
					wren = 0;
					addr_reg = 0;
					immediate = 0;
					alu_func = 0;
					next = 0;
				end
				
			endcase
		
		end
	
	end

endmodule

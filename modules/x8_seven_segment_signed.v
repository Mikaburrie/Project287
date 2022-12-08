module x8_seven_segment_signed(num, radix, segs);

	input [4:0] radix;
	input [31:0] num;
	output reg [55:0] segs;
	
	wire [6:0] seg1, seg2, seg3, seg4, seg5, seg6, seg7;
	reg [30:0] div0, div1, div2, div3, div4, div5, div6;
	
	seven_segment SEG1(div0 % radix, seg1);
	seven_segment SEG2(div1 % radix, seg2);
	seven_segment SEG3(div2 % radix, seg3);
	seven_segment SEG4(div3 % radix, seg4);
	seven_segment SEG5(div4 % radix, seg5);
	seven_segment SEG6(div5 % radix, seg6);
	seven_segment SEG7(div6 % radix, seg7);
	
	always @(*) begin
	
		segs = {6'b111111, ~num[31], seg7, seg6, seg5, seg4, seg3, seg2, seg1};
		
		if (num[31])
			div0 = -num;
		else
			div0 = num;
		
		div1 = div0 / radix;
		div2 = div1 / radix;
		div3 = div2 / radix;
		div4 = div3 / radix;
		div5 = div4 / radix;
		div6 = div5 / radix;
		
	end

endmodule



module seven_segment(num, segs);

	input [30:0] num;
	output reg [6:0] segs;

	always @(*) begin
	
		case (num[3:0])
		
			4'h0: segs = 7'b0000001;
			4'h1: segs = 7'b1001111;
			4'h2: segs = 7'b0010010;
			4'h3: segs = 7'b0000110;
			4'h4: segs = 7'b1001100;
			4'h5: segs = 7'b0100100;
			4'h6: segs = 7'b0100000;
			4'h7: segs = 7'b0001111;
			4'h8: segs = 7'b0000000;
			4'h9: segs = 7'b0000100;
			4'ha: segs = 7'b0001000;
			4'hb: segs = 7'b1100000;
			4'hc: segs = 7'b1110010;
			4'hd: segs = 7'b1000010;
			4'he: segs = 7'b0110000;
			4'hf: segs = 7'b0111000;
		
		endcase
	
	end
	
endmodule

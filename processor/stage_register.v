module stage_register(w1, w2, w3, w4, clock, clr, w_en, r1, r2, r3, r4);

	input [11:0] w1;
	output [11:0] r1;
	input [31:0] w2, w3, w4;
	output [31:0] r2, r3, r4;
	input clock, clr, w_en;
	
	// declare registers
	
	wire [31:0] w1_in, r1_out;
	assign w1_in[11:0] = w1;
	assign r1 = r1_out[11:0];
	
	register register1(.w(w1_in), .clock(clock), .clr(clr), .w_en(w_en), .r(r1_out));
	register register2(.w(w2), .clock(clock), .clr(clr), .w_en(w_en), .r(r2));
	register register3(.w(w3), .clock(clock), .clr(clr), .w_en(w_en), .r(r3));
	register register4(.w(w4), .clock(clock), .clr(clr), .w_en(w_en), .r(r4));

endmodule

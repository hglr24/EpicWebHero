module right_shift(data_operandA, ctrl_shiftamt, result);

	input [31:0] data_operandA;
   input [4:0] ctrl_shiftamt;
	
	output [31:0] result;
	
	wire [31:0] out16, out8, out4, out2, out1;
	wire [31:0] mux_out16, mux_out8, mux_out4, mux_out2, mux_out1;
		
	// perform 32-bit right arithmetic shift
	
	right_shift16 ls16(.in(data_operandA), .out(out16));
	mux_2 mux1(.in1(data_operandA), .in2(out16), .select(ctrl_shiftamt[4]), .out(mux_out16));
	right_shift8 ls8(.in(mux_out16), .out(out8));
	mux_2 mux2(.in1(mux_out16), .in2(out8), .select(ctrl_shiftamt[3]), .out(mux_out8));
	right_shift4 ls4(.in(mux_out8), .out(out4));
	mux_2 mux3(.in1(mux_out8), .in2(out4), .select(ctrl_shiftamt[2]), .out(mux_out4));
	right_shift2 ls2(.in(mux_out4), .out(out2));
	mux_2 mux4(.in1(mux_out4), .in2(out2), .select(ctrl_shiftamt[1]), .out(mux_out2));
	right_shift1 ls1(.in(mux_out2), .out(out1));
	mux_2 mux5(.in1(mux_out2), .in2(out1), .select(ctrl_shiftamt[0]), .out(result));

endmodule

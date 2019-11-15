module isEqual(in1, in2, out);

	input [4:0] in1, in2;
	output out;

	wire [4:0] result;
	
	xnor (result[0], in1[0], in2[0]);
	xnor (result[1], in1[1], in2[1]);
	xnor (result[2], in1[2], in2[2]);
	xnor (result[3], in1[3], in2[3]);
	xnor (result[4], in1[4], in2[4]);
	
	and (out, result[0], result[1], result[2], result[3], result[4]);
	
endmodule

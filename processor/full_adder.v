module full_adder(in1, in2, c_in, sum, c_out);

	input in1, in2, c_in;
	output sum, c_out;
	
	wire w0, w1, w2;

	xor(w0, in1, in2);
	and(w1, in1, in2);
	and(w2, c_in, w0);
	xor(sum, c_in, w0);
	or(c_out, w1, w2);

endmodule

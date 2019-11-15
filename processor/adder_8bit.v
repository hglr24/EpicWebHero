module adder_8bit(in1, in2, p_in, g_in, c_in, sum);

	input [7:0] in1, in2, p_in, g_in;
	input c_in;
	output [7:0] sum;
	
	wire c1, c2, c3, c4, c5, c6, c7;
	
	wire c1_1;
	wire c2_1, c2_2;
	wire c3_1, c3_2, c3_3;
	wire c4_1, c4_2, c4_3, c4_4;
	wire c5_1, c5_2, c5_3, c5_4, c5_5;
	wire c6_1, c6_2, c6_3, c6_4, c6_5, c6_6;
	wire c7_1, c7_2, c7_3, c7_4, c7_5, c7_6, c7_7;
	wire c8_1, c8_2, c8_3, c8_4, c8_5, c8_6, c8_7, c8_8;
	
	// perform carry lookahead logic bit-by-bit
	
	// c1
	
	and andc1_1(c1_1, p_in[0], c_in);
	or orc1(c1, g_in[0], c1_1);
	
	// c2
	
	and andc2_1(c2_1, p_in[1], g_in[0]);
	and andc2_2(c2_2, p_in[1], p_in[0], c_in);
	or orc2(c2, g_in[1], c2_1, c2_2);
	
	
	// c3
	
	and andc3_1(c3_1, p_in[2], g_in[1]);
	and andc3_2(c3_2, p_in[2], p_in[1], g_in[0]);
	and andc3_3(c3_3, p_in[2], p_in[1], p_in[0], c_in);
	or orc3(c3, g_in[2], c3_1, c3_2, c3_3);
	
	// c4
	
	and andc4_1(c4_1, p_in[3], g_in[2]);
	and andc4_2(c4_2, p_in[3], p_in[2], g_in[1]);
	and andc4_3(c4_3, p_in[3], p_in[2], p_in[1], g_in[0]);
	and andc4_4(c4_4, p_in[3], p_in[2], p_in[1], p_in[0], c_in);
	or orc4(c4, g_in[3], c4_1, c4_2, c4_3, c4_4);
	
	// c5
	
	and andc5_1(c5_1, p_in[4], g_in[3]);
	and andc5_2(c5_2, p_in[4], p_in[3], g_in[2]);
	and andc5_3(c5_3, p_in[4], p_in[3], p_in[2], g_in[1]);
	and andc5_4(c5_4, p_in[4], p_in[3], p_in[2], p_in[1], g_in[0]);
	and andc5_5(c5_5, p_in[4], p_in[3], p_in[2], p_in[1], p_in[0], c_in);
	or orc5(c5, g_in[4], c5_1, c5_2, c5_3, c5_4, c5_5);
	
	// c6
	
	and andc6_1(c6_1, p_in[5], g_in[4]);
	and andc6_2(c6_2, p_in[5], p_in[4], g_in[3]);
	and andc6_3(c6_3, p_in[5], p_in[4], p_in[3], g_in[2]);
	and andc6_4(c6_4, p_in[5], p_in[4], p_in[3], p_in[2], g_in[1]);
	and andc6_5(c6_5, p_in[5], p_in[4], p_in[3], p_in[2], p_in[1], g_in[0]);
	and andc6_6(c6_6, p_in[5], p_in[4], p_in[3], p_in[2], p_in[1], p_in[0], c_in);
	or orc6(c6, g_in[5], c6_1, c6_2, c6_3, c6_4, c6_5, c6_6);
	
	// c7
	
	and andc7_1(c7_1, p_in[6], g_in[5]);
	and andc7_2(c7_2, p_in[6], p_in[5], g_in[4]);
	and andc7_3(c7_3, p_in[6], p_in[5], p_in[4], g_in[3]);
	and andc7_4(c7_4, p_in[6], p_in[5], p_in[4], p_in[3], g_in[2]);
	and andc7_5(c7_5, p_in[6], p_in[5], p_in[4], p_in[3], p_in[2], g_in[1]);
	and andc7_6(c7_6, p_in[6], p_in[5], p_in[4], p_in[3], p_in[2], p_in[1], g_in[0]);
	and andc7_7(c7_7, p_in[6], p_in[5], p_in[4], p_in[3], p_in[2], p_in[1], p_in[0], c_in);
	or orc7(c7, g_in[6], c7_1, c7_2, c7_3, c7_4, c7_5, c7_6, c7_7);
	
	// c8
	
	and andc8_1(c8_1, p_in[7], g_in[6]);
	and andc8_2(c8_2, p_in[7], p_in[6], g_in[5]);
	and andc8_3(c8_3, p_in[7], p_in[6], p_in[5], g_in[4]);
	and andc8_4(c8_4, p_in[7], p_in[6], p_in[5], p_in[4], g_in[3]);
	and andc8_5(c8_5, p_in[7], p_in[6], p_in[5], p_in[4], p_in[3], g_in[2]);
	and andc8_6(c8_6, p_in[7], p_in[6], p_in[5], p_in[4], p_in[3], p_in[2], g_in[1]);
	and andc8_7(c8_7, p_in[7], p_in[6], p_in[5], p_in[4], p_in[3], p_in[2], p_in[1], g_in[0]);
	and andc8_8(c8_8, p_in[7], p_in[6], p_in[5], p_in[4], p_in[3], p_in[2], p_in[1], p_in[0], c_in);
	or orc8(c8, g_in[7], c8_1, c8_2, c8_3, c8_4, c8_5, c8_6, c8_7, c8_8);
	
	// evaluate full adders with determined carries
	
	full_adder add0(.in1(in1[0]), .in2(in2[0]), .c_in(c_in), .sum(sum[0]), .c_out());
	full_adder add1(.in1(in1[1]), .in2(in2[1]), .c_in(c1), .sum(sum[1]), .c_out());
	full_adder add2(.in1(in1[2]), .in2(in2[2]), .c_in(c2), .sum(sum[2]), .c_out());
	full_adder add3(.in1(in1[3]), .in2(in2[3]), .c_in(c3), .sum(sum[3]), .c_out());
	full_adder add4(.in1(in1[4]), .in2(in2[4]), .c_in(c4), .sum(sum[4]), .c_out());
	full_adder add5(.in1(in1[5]), .in2(in2[5]), .c_in(c5), .sum(sum[5]), .c_out());
	full_adder add6(.in1(in1[6]), .in2(in2[6]), .c_in(c6), .sum(sum[6]), .c_out());
	full_adder add7(.in1(in1[7]), .in2(in2[7]), .c_in(c7), .sum(sum[7]), .c_out());

endmodule

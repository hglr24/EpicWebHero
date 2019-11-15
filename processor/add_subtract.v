module add_subtract(data_operandA, data_operandB, subtract, g_in, p_in, sum, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB, g_in, p_in;
   input subtract; // if 0, add; if 1, subtract (invert B and add 1)

   output [31:0] sum;
   output isNotEqual, isLessThan, overflow;
	
	wire big_p0, big_p1, big_p2, big_p3;
	
	wire big_g0, big_g1, big_g2, big_g3;
	wire g0_1, g0_2, g0_3, g0_4, g0_5, g0_6, g0_7;
	wire g1_1, g1_2, g1_3, g1_4, g1_5, g1_6, g1_7;
	wire g2_1, g2_2, g2_3, g2_4, g2_5, g2_6, g2_7;
	wire g3_1, g3_2, g3_3, g3_4, g3_5, g3_6, g3_7;
	
	wire c8, c16, c24, c32;
	wire c8_1;
	wire c16_1, c16_2;
	wire c24_1, c24_2, c23_3;
	wire c32_1, c32_2, c32_3, c32_4;
	
	wire lt_not;
	
	// perform second-level lookahead
	
	// determine P's
	
	and p0and(big_p0, p_in[0], p_in[1], p_in[2], p_in[3], p_in[4], p_in[5], p_in[6], p_in[7]);
	and p1and(big_p1, p_in[8], p_in[9], p_in[10], p_in[11], p_in[12], p_in[13], p_in[14], p_in[15]);
	and p2and(big_p2, p_in[16], p_in[17], p_in[18], p_in[19], p_in[20], p_in[21], p_in[22], p_in[23]);
	and p3and(big_p3, p_in[24], p_in[25], p_in[26], p_in[27], p_in[28], p_in[29], p_in[30], p_in[31]);
	
	// determine G's
	
	// G0
	
	and andg0_1(g0_1, p_in[7], g_in[6]);
	and andg0_2(g0_2, p_in[7], p_in[6], g_in[5]);
	and andg0_3(g0_3, p_in[7], p_in[6], p_in[5], g_in[4]);
	and andg0_4(g0_4, p_in[7], p_in[6], p_in[5], p_in[4], g_in[3]);
	and andg0_5(g0_5, p_in[7], p_in[6], p_in[5], p_in[4], p_in[3], g_in[2]);
	and andg0_6(g0_6, p_in[7], p_in[6], p_in[5], p_in[4], p_in[3], p_in[2], g_in[1]);
	and andg0_7(g0_7, p_in[7], p_in[6], p_in[5], p_in[4], p_in[3], p_in[2], p_in[1], g_in[0]);
	or org0(big_g0, g_in[7], g0_1, g0_2, g0_3, g0_4, g0_5, g0_6, g0_7);
	
	// G1
	
	and andg1_1(g1_1, p_in[15], g_in[14]);
	and andg1_2(g1_2, p_in[15], p_in[14], g_in[13]);
	and andg1_3(g1_3, p_in[15], p_in[14], p_in[13], g_in[12]);
	and andg1_4(g1_4, p_in[15], p_in[14], p_in[13], p_in[12], g_in[11]);
	and andg1_5(g1_5, p_in[15], p_in[14], p_in[13], p_in[12], p_in[11], g_in[10]);
	and andg1_6(g1_6, p_in[15], p_in[14], p_in[13], p_in[12], p_in[11], p_in[10], g_in[9]);
	and andg1_7(g1_7, p_in[15], p_in[14], p_in[13], p_in[12], p_in[11], p_in[10], p_in[9], g_in[8]);
	or org1(big_g1, g_in[15], g1_1, g1_2, g1_3, g1_4, g1_5, g1_6, g1_7);
	
	// G2
	
	and andg2_1(g2_1, p_in[23], g_in[22]);
	and andg2_2(g2_2, p_in[23], p_in[22], g_in[21]);
	and andg2_3(g2_3, p_in[23], p_in[22], p_in[21], g_in[20]);
	and andg2_4(g2_4, p_in[23], p_in[22], p_in[21], p_in[20], g_in[19]);
	and andg2_5(g2_5, p_in[23], p_in[22], p_in[21], p_in[20], p_in[19], g_in[18]);
	and andg2_6(g2_6, p_in[23], p_in[22], p_in[21], p_in[20], p_in[19], p_in[18], g_in[17]);
	and andg2_7(g2_7, p_in[23], p_in[22], p_in[21], p_in[20], p_in[19], p_in[18], p_in[17], g_in[16]);
	or org2(big_g2, g_in[23], g2_1, g2_2, g2_3, g2_4, g2_5, g2_6, g2_7);
	
	// G3
	
	and andg3_1(g3_1, p_in[31], g_in[30]);
	and andg3_2(g3_2, p_in[31], p_in[30], g_in[29]);
	and andg3_3(g3_3, p_in[31], p_in[30], p_in[29], g_in[28]);
	and andg3_4(g3_4, p_in[31], p_in[30], p_in[29], p_in[28], g_in[27]);
	and andg3_5(g3_5, p_in[31], p_in[30], p_in[29], p_in[28], p_in[27], g_in[26]);
	and andg3_6(g3_6, p_in[31], p_in[30], p_in[29], p_in[28], p_in[27], p_in[26], g_in[25]);
	and andg3_7(g3_7, p_in[31], p_in[30], p_in[29], p_in[28], p_in[27], p_in[26], p_in[25], g_in[24]);
	or org3(big_g3, g_in[31], g3_1, g3_2, g3_3, g3_4, g3_5, g3_6, g3_7);
	
	// determine c's
	
	// c8
	
	and andc8_1(c8_1, big_p0, subtract);
	or orc8(c8, big_g0, c8_1);
	
	// c16
	
	and andc16_1(c16_1, big_p1, big_g0);
	and andc16_2(c16_2, big_p1, big_p0, subtract);
	or orc16(c16, big_g1, c16_1, c16_2);
	
	// c24
	
	and andc24_1(c24_1, big_p2, big_g1);
	and andc24_2(c24_2, big_p2, big_p1, big_g0);
	and andc24_3(c24_3, big_p2, big_p1, big_p0, subtract);
	or orc24(c24, big_g2, c24_1, c24_2, c24_3);
	
	// c32
	
	and andc32_1(c32_1, big_p3, big_g2);
	and andc32_2(c32_2, big_p3, big_p2, big_g1);
	and andc32_3(c32_3, big_p3, big_p2, big_p1, big_g0);
	and andc32_4(c32_4, big_p3, big_p2, big_p1, big_p0, subtract);
	or orc32(c32, big_g3, c32_1, c32_2, c32_3, c32_4);
	
	// perform carry lookahead add/subtract
	
	adder_8bit add0_7(.in1(data_operandA[7:0]), .in2(data_operandB[7:0]), .p_in(p_in[7:0]), 
		.g_in(g_in[7:0]), .c_in(subtract), .sum(sum[7:0]));
		
	adder_8bit add8_15(.in1(data_operandA[15:8]), .in2(data_operandB[15:8]), .p_in(p_in[15:8]), 
		.g_in(g_in[15:8]), .c_in(c8), .sum(sum[15:8]));
		
	adder_8bit add16_23(.in1(data_operandA[23:16]), .in2(data_operandB[23:16]), .p_in(p_in[23:16]), 
		.g_in(g_in[23:16]), .c_in(c16), .sum(sum[23:16]));
		
	adder_8bit add24_31(.in1(data_operandA[31:24]), .in2(data_operandB[31:24]), .p_in(p_in[31:24]), 
		.g_in(g_in[31:24]), .c_in(c24), .sum(sum[31:24]));
		
	// determine if overflow occurred (only matters for add and subtract)
	
	xnor over_xnor1(over_w1, data_operandA[31], data_operandB[31]);
	xnor over_xnor2(over_w2, data_operandA[31], sum[31]);
	not over_not(over_w3, over_w2);
	and over_and(overflow, over_w1, over_w3);
	
	// determine if inputs are not equal (only matters for subtract)
	
	nor eq_nor(eq_w, sum[0], sum[1], sum[2], sum[3], sum[4], sum[5], sum[6], sum[7], sum[8], sum[9], sum[10], 
		sum[11], sum[12], sum[13], sum[14], sum[15], sum[16], sum[17], sum[18], sum[19], sum[20], sum[21], sum[22], sum[23], sum[24], 
		sum[25], sum[26], sum[27], sum[28], sum[29], sum[30], sum[31]);
	not eq_not(isNotEqual, eq_w);
	
	// determine if input A is less than input B (only matters for subtract)
	
	not (lt_not, sum[31]);
	mux_2 lt_mx(.in1(sum[31]), .in2(lt_not), .select(overflow), .out(isLessThan));

endmodule

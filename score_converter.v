module score_converter(score, score_digit_a, score_digit_b, score_digit_c, score_digit_d);

	// displayed (left to right) as A B C D (D is least significant digit)

	input [31:0] score;
	output [6:0] score_digit_a, score_digit_b, score_digit_c, score_digit_d;
	
	wire [3:0] score_ones, score_tens, score_hundreds, score_thousands;
	
	assign score_ones = score % 32'd10;
	assign score_tens = (score % 32'd100) / 32'd10;
	assign score_hundreds = (score % 32'd1000) / 32'd100;
	assign score_thousands = score / 32'd1000;
	
	assign score_digit_d[0] = (~score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && ~score_ones[2] && score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && ~score_ones[2] && score_ones[1] && score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && ~score_ones[1] && score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && score_ones[1] && score_ones[0]) || 
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && score_ones[0]); // 0 2 3 5 6 7 8 9
	assign score_digit_d[1] = (~score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && ~score_ones[2] && ~score_ones[1] && score_ones[0]) || 
				(~score_ones[3] && ~score_ones[2] && score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && ~score_ones[2] && score_ones[1] && score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && score_ones[1] && score_ones[0]) || 
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && score_ones[0]); // 0 1 2 3 4 7 8 9
	assign score_digit_d[2] = (~score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && ~score_ones[2] && ~score_ones[1] && score_ones[0]) || 
				(~score_ones[3] && ~score_ones[2] && score_ones[1] && score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && ~score_ones[1] && score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && score_ones[1] && ~score_ones[0]) ||
				(~score_ones[3] && score_ones[2] && score_ones[1] && score_ones[0]) ||
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && score_ones[0]); // 0 1 3 4 5 6 7 8 9
	assign score_digit_d[3] = (~score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && ~score_ones[2] && score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && ~score_ones[2] && score_ones[1] && score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && ~score_ones[1] && score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && score_ones[1] && ~score_ones[0]) || 
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && score_ones[0]); // 0 2 3 5 6 8 9
	assign score_digit_d[4] = (~score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && ~score_ones[2] && score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && score_ones[1] && ~score_ones[0]) || 
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]); // 0 2 6 8 
	assign score_digit_d[5] = (~score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && ~score_ones[1] && score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && score_ones[1] && ~score_ones[0]) ||
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && score_ones[0]); // 0 4 5 6 8 9
	assign score_digit_d[6] = (~score_ones[3] && ~score_ones[2] && score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && ~score_ones[2] && score_ones[1] && score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && ~score_ones[1] && score_ones[0]) || 
				(~score_ones[3] && score_ones[2] && score_ones[1] && ~score_ones[0]) || 
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && ~score_ones[0]) || 
				(score_ones[3] && ~score_ones[2] && ~score_ones[1] && score_ones[0]); // 2 3 4 5 6 8 9
				
	assign score_digit_c[0] = (~score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && ~score_tens[2] && score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && ~score_tens[2] && score_tens[1] && score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && ~score_tens[1] && score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && score_tens[1] && score_tens[0]) || 
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && score_tens[0]); // 0 2 3 5 6 7 8 9
	assign score_digit_c[1] = (~score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && ~score_tens[2] && ~score_tens[1] && score_tens[0]) || 
				(~score_tens[3] && ~score_tens[2] && score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && ~score_tens[2] && score_tens[1] && score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && score_tens[1] && score_tens[0]) || 
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && score_tens[0]); // 0 1 2 3 4 7 8 9
	assign score_digit_c[2] = (~score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && ~score_tens[2] && ~score_tens[1] && score_tens[0]) || 
				(~score_tens[3] && ~score_tens[2] && score_tens[1] && score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && ~score_tens[1] && score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && score_tens[1] && ~score_tens[0]) ||
				(~score_tens[3] && score_tens[2] && score_tens[1] && score_tens[0]) ||
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && score_tens[0]); // 0 1 3 4 5 6 7 8 9
	assign score_digit_c[3] = (~score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && ~score_tens[2] && score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && ~score_tens[2] && score_tens[1] && score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && ~score_tens[1] && score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && score_tens[1] && ~score_tens[0]) || 
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && score_tens[0]); // 0 2 3 5 6 8 9
	assign score_digit_c[4] = (~score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && ~score_tens[2] && score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && score_tens[1] && ~score_tens[0]) || 
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]); // 0 2 6 8 
	assign score_digit_c[5] = (~score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && ~score_tens[1] && score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && score_tens[1] && ~score_tens[0]) ||
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && score_tens[0]); // 0 4 5 6 8 9
	assign score_digit_c[6] = (~score_tens[3] && ~score_tens[2] && score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && ~score_tens[2] && score_tens[1] && score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && ~score_tens[1] && score_tens[0]) || 
				(~score_tens[3] && score_tens[2] && score_tens[1] && ~score_tens[0]) || 
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && ~score_tens[0]) || 
				(score_tens[3] && ~score_tens[2] && ~score_tens[1] && score_tens[0]); // 2 3 4 5 6 8 9
				
	assign score_digit_b[0] = (~score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && ~score_hundreds[2] && score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && ~score_hundreds[2] && score_hundreds[1] && score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && score_hundreds[1] && score_hundreds[0]) || 
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]); // 0 2 3 5 6 7 8 9
	assign score_digit_b[1] = (~score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]) || 
				(~score_hundreds[3] && ~score_hundreds[2] && score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && ~score_hundreds[2] && score_hundreds[1] && score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && score_hundreds[1] && score_hundreds[0]) || 
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]); // 0 1 2 3 4 7 8 9
	assign score_digit_b[2] = (~score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]) || 
				(~score_hundreds[3] && ~score_hundreds[2] && score_hundreds[1] && score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && score_hundreds[1] && ~score_hundreds[0]) ||
				(~score_hundreds[3] && score_hundreds[2] && score_hundreds[1] && score_hundreds[0]) ||
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]); // 0 1 3 4 5 6 7 8 9
	assign score_digit_b[3] = (~score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && ~score_hundreds[2] && score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && ~score_hundreds[2] && score_hundreds[1] && score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && score_hundreds[1] && ~score_hundreds[0]) || 
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]); // 0 2 3 5 6 8 9
	assign score_digit_b[4] = (~score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && ~score_hundreds[2] && score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && score_hundreds[1] && ~score_hundreds[0]) || 
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]); // 0 2 6 8 
	assign score_digit_b[5] = (~score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && score_hundreds[1] && ~score_hundreds[0]) ||
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]); // 0 4 5 6 8 9
	assign score_digit_b[6] = (~score_hundreds[3] && ~score_hundreds[2] && score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && ~score_hundreds[2] && score_hundreds[1] && score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]) || 
				(~score_hundreds[3] && score_hundreds[2] && score_hundreds[1] && ~score_hundreds[0]) || 
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && ~score_hundreds[0]) || 
				(score_hundreds[3] && ~score_hundreds[2] && ~score_hundreds[1] && score_hundreds[0]); // 2 3 4 5 6 8 9
				
	assign score_digit_a[0] = (~score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && ~score_thousands[2] && score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && ~score_thousands[2] && score_thousands[1] && score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && ~score_thousands[1] && score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && score_thousands[1] && score_thousands[0]) || 
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && score_thousands[0]); // 0 2 3 5 6 7 8 9
	assign score_digit_a[1] = (~score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && score_thousands[0]) || 
				(~score_thousands[3] && ~score_thousands[2] && score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && ~score_thousands[2] && score_thousands[1] && score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && score_thousands[1] && score_thousands[0]) || 
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && score_thousands[0]); // 0 1 2 3 4 7 8 9
	assign score_digit_a[2] = (~score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && score_thousands[0]) || 
				(~score_thousands[3] && ~score_thousands[2] && score_thousands[1] && score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && ~score_thousands[1] && score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && score_thousands[1] && ~score_thousands[0]) ||
				(~score_thousands[3] && score_thousands[2] && score_thousands[1] && score_thousands[0]) ||
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && score_thousands[0]); // 0 1 3 4 5 6 7 8 9
	assign score_digit_a[3] = (~score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && ~score_thousands[2] && score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && ~score_thousands[2] && score_thousands[1] && score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && ~score_thousands[1] && score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && score_thousands[1] && ~score_thousands[0]) || 
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && score_thousands[0]); // 0 2 3 5 6 8 9
	assign score_digit_a[4] = (~score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && ~score_thousands[2] && score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && score_thousands[1] && ~score_thousands[0]) || 
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]); // 0 2 6 8 
	assign score_digit_a[5] = (~score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && ~score_thousands[1] && score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && score_thousands[1] && ~score_thousands[0]) ||
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && score_thousands[0]); // 0 4 5 6 8 9
	assign score_digit_a[6] = (~score_thousands[3] && ~score_thousands[2] && score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && ~score_thousands[2] && score_thousands[1] && score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && ~score_thousands[1] && score_thousands[0]) || 
				(~score_thousands[3] && score_thousands[2] && score_thousands[1] && ~score_thousands[0]) || 
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && ~score_thousands[0]) || 
				(score_thousands[3] && ~score_thousands[2] && ~score_thousands[1] && score_thousands[0]); // 2 3 4 5 6 8 9
	
endmodule

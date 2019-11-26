module score_tester(clock, reset, ten, hund, thous, score_digit_a, score_digit_b, score_digit_c, score_digit_d);

	input clock, reset, ten, hund, thous;
	output [6:0] score_digit_a, score_digit_b, score_digit_c, score_digit_d;
	
	reg [31:0] score; // current game score
	reg [31:0] debounce;
	
	score_converter s_c(score, score_digit_a, score_digit_b, score_digit_c, score_digit_d); // D is LSD, A is MSD
	
	initial begin
		score <= 32'd0;
		debounce <= 32'd0;
	end
	
	always @(posedge clock) begin
		if (reset == 0 && debounce >= 32'd50000000) begin
			score <= score + 32'd1;
			debounce <= 32'd0;
		end else if (ten == 0 && debounce >= 32'd50000000) begin
			score <= score + 32'd10;
			debounce <= 32'd0;
		end else if (hund == 0 && debounce >= 32'd50000000) begin
			score <= score + 32'd100;
			debounce <= 32'd0;
		end else if (thous == 0 && debounce >= 32'd50000000) begin
			score <= score + 32'd1000;
			debounce <= 32'd0;
		end else begin
			debounce <= debounce + 32'd1;
		end
	end

endmodule

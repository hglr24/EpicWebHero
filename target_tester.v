module target_tester(clock, target_a, target_b, photo_array, flex_r, flex_l, laser_r, laser_l, score_digit_a, score_digit_b, score_digit_c, score_digit_d);
output [3:0] target_a, target_b;
input clock, flex_l, flex_r;
input [9:0] photo_array;
output laser_r, laser_l;
output [6:0] score_digit_a, score_digit_b, score_digit_c, score_digit_d;

reg [3:0] target_a, target_b;
reg a;
reg [31:0] score;

laser_driver right_glove_laser(.clock(clock), .in(flex_r), .out(laser_r));
laser_driver left_glove_laser(.clock(clock), .in(flex_l), .out(laser_l));

score_converter s_c(score, score_digit_a, score_digit_b, score_digit_c, score_digit_d); // D is LSD, A is MSD

initial begin
		a <= 1;
		target_a <= 8;
		target_b <= 9;
		score <= 0;
		
end

always @(negedge photo_array[8]) begin
	score <= score + 32'd250;
	target_a <= 9;
end

always @(negedge photo_array[9]) begin
	target_b <= 8;
end

endmodule
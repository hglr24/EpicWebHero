module photo_test (clock, reset, photo_array, flex_r, flex_l, laser_r, laser_l, target_a, target_b, 
								score_digit_a, score_digit_b, score_digit_c, score_digit_d, photo_led_delete_later);
								
	input clock, reset, flex_l, flex_r;
	input [9:0] photo_array; // todo
	
	output laser_r, laser_l;
	output [3:0] target_a, target_b; // todo
	output [6:0] score_digit_a, score_digit_b, score_digit_c, score_digit_d;
	
	output [9:0] photo_led_delete_later;
	
	assign photo_led_delete_later = photo_array;
	
endmodule
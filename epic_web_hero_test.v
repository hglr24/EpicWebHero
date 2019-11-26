module epic_web_hero_test (clock, reset, photo_array, flex_r, flex_l, laser_r, laser_l, target_a, target_b, 
								score_digit_a, score_digit_b, score_digit_c, score_digit_d);

	input clock, reset, flex_l, flex_r;
	input [9:0] photo_array; // todo
	
	output laser_r, laser_l;
	output [3:0] target_a, target_b; // todo
	output [6:0] score_digit_a, score_digit_b, score_digit_c, score_digit_d;
	
	//wire [31:0] score; // current game score
	reg [31:0] counter;
	reg [31:0] targetIndex;
	reg [3:0] target_a;
	reg [3:0] target_b;
	reg a;
	reg [31:0] score;
	
	/** EXT. HARDWARE INTERACTION COMPONENTS BELOW **/
	
	// declare score converter
	
	score_converter s_c(score, score_digit_a, score_digit_b, score_digit_c, score_digit_d); // D is LSD, A is MSD
	
	// declare laser drivers for each glove
	
	laser_driver right_glove_laser(.clock(clock), .in(flex_r), .out(laser_r));
	laser_driver left_glove_laser(.clock(clock), .in(flex_l), .out(laser_l));
	
	/** NEW PROCESSOR/CONTROL COMPONENTS BELOW **/
	
	wire [3:0] rand_num_ten;
	random_num_gen ewh_rng(.score(score), .clock(clock), .ranNumTen(rand_num_ten));
	wire timer_done;
	wire [31:0] timer_length;
	timer ewh_timer(.clock(clock), .timerLength(timer_length), .start(), .out(timer_done)); // todo is start necessary?
	target_selector ewh_targ_sel();
	
	
	initial begin
		counter <= 0;
		targetIndex <= 0;
		target_a <= targetIndex;
		a <= 1;
	end


always @(posedge photo_array[targetIndex]) begin
	targetIndex <= targetIndex + 1;
	score <= score + 100;
	if(targetIndex == 32'd10) begin
		a = ~a;
		targetIndex <= 0;
	end 
	else if (a == 1) begin
		target_a <= targetIndex;
	end
	else begin
		target_b <= targetIndex;
	end
end
	 

endmodule

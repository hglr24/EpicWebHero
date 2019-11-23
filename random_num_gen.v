module random_num_gen(clock, min, max, score, timeElapsed, ranNum);
input clock;
input [31:0] min, max;	//defining the range of the desired value
input [31:0] score, timeElapsed;	//player's score, time since started
output [31:0] ranNum;	//random value produced within the designated range

reg [31:0] inter, ranNum;

	initial begin
		inter <= 0;
	end
	
	always @(posedge clock) begin
		inter <= timeElapsed / score;
		ranNum <= ((max - min) * (inter - min) / (max - min)) + inter;
	end
endmodule
module random_num_gen(score, clock, ranNumTen);
input clock;
input [31:0] score;
output [3:0] ranNumTen;

reg [31:0] ranNum;
reg [31:0] ranNumTen;
reg [31:0] rand_count;

initial begin
		ranNum <= 4'd2;
		rand_count <= 32'd0;
		ranNumTen <= 32'd0;
end

always @(posedge clock) begin
		//pseudo-random num algorithm found at https://www.geeksforgeeks.org/pseudo-random-number-generator-prng/
		ranNum <= (3*ranNum + rand_count) % (score);	//generating a random value
		ranNumTen <= ranNum % 10;		//mapping that random value to between 0 and 9 for target selection
		rand_count <= rand_count + 1;
		if(rand_count >= 32'd2000000) begin
			rand_count <= 32'd0;
		end
end

endmodule

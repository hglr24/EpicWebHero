module random_num_gen(score, clock, ranNum, ranNumTen, ranNumLength);
input clock;
input [31:0] score;//, currentTime;
output [31:0] ranNum, ranNumLength;
output [3:0] ranNumTen;

reg [31:0] ranNum;
reg [3:0] ranNumTen;
reg [31:0] counter;
reg [31:0] rand_count;

initial begin
		ranNum <= 4'd2;
		counter <= 32'd0;
		rand_count <= 32'd0;
end

always @(posedge clock) begin
	if (counter >= 25000000) begin
		ranNum = (3*ranNum + rand_count) % (score);	//generating a random value
		ranNumTen = ranNum % 10;		//mapping that random value to between 0 and 9 for target selection
		rand_count <= rand_count + 1;
		counter <= 32'd0;
	end else begin
		counter <= counter + 1;
	end
end

endmodule

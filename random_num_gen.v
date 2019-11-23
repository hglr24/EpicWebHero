module ran_num_generator(score, clk, ranNum, ranNumTen, ranNumLength);
input clk;
input [31:0] score;//, currentTime;
output [31:0] ranNum, ranNumTen, ranNumLength;

reg [31:0] ranNum, ranNumTen;
reg [31:0] counter;

initial begin
		ranNum <= 32'd2;
		counter <= 32'd0;
end

always @(posedge clk) begin
	counter <= counter + 1;
	ranNum = (3*ranNum + counter) % (score);	//generating a random value
	ranNumTen = ranNum % 10;		//mapping that random value to between 0 and 9 for target selection
	ranNumLength = (score % 5)
end

endmodule

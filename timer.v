module timer(clock, timerLength, start, out, length);
input clock, start;
input [31:0] timerLength;	//currently in seconds, only needs to be set when start is enabled
output out;	//high while clock is active	
output [31:0] length;

reg [31:0] secondsCounter;
reg [31:0] cyclesCounter;
reg [31:0] length;
reg out;

initial begin
		out <= 1'b0;
		secondsCounter <= 32'd0;
		cyclesCounter <= 32'd0;
		length <= 32'b0;
end
	
	always @(posedge clock) begin
		//if clocked at 50MHz, 50E6 cycles per second
		if (cyclesCounter == 32'd50000000) begin
			secondsCounter <= secondsCounter + 1;
			cyclesCounter <= 32'd0;
		end else
			cyclesCounter <= cyclesCounter + 1;
		
		//timer has finished
		if (secondsCounter == length) begin
			out <= 1'b0;
		end
		
		if (start == 1'b1) begin
			out <= 1'b1;
			cyclesCounter <= 32'd0;
			secondsCounter <= 32'd0;
			length <= timerLength;
		end
	end

endmodule
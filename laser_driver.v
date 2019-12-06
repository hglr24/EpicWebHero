module laser_driver(clock, in, out);

	input in, clock;
	reg outreg;
	reg [31:0] timer;
	output out;
	assign out = outreg;
	
	initial begin
		timer <= 32'd0;
		outreg <= 1;
	end
	
	always @(posedge clock) begin
		if (in == 1) begin
			outreg <= 1; // off
			timer <= 32'd0;
		end else if (timer >= 32'd150000000) begin
			outreg <= 1; // off
		end else begin
			outreg <= 0; // on
			timer <= timer + 32'd1;
		end 
	end
	
endmodule

module laser_driver(clock, in, out);

	input in, clock;
	reg outreg;
	reg [31:0] cooldown;
	output out;
	assign out = outreg;
	
	initial begin
		cooldown <= 32'd0;
		outreg <= 1;
	end
	
	always @(posedge clock) begin
		if (in == 0 && cooldown == 32'd0) begin
			outreg <= 0; // on
			cooldown <= cooldown + 32'd1;
		end else if (cooldown >= 32'd200000000) begin // then 2 seconds laser OFF (cooldown)
			cooldown <= 32'd0;
		end else if (cooldown >= 32'd100000000) begin // 2 seconds laser ON
			outreg <= 1; // off
			cooldown <= cooldown + 32'd1;	
		end else if (cooldown > 0)
			cooldown <= cooldown + 32'd1; // increment cooldown counter
	end
	
endmodule

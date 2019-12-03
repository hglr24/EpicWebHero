module target_tester(clock, target_a, target_b);
input clock;
output [3:0] target_a, target_b;

reg [3:0] target_a, target_b;
reg [31:0] count;
reg a;
initial begin
		a <= 1;
		count <= 0;
		target_a <= 0;
		target_b <= 0;
end

always @(posedge clock) begin
	count <= count + 1;
	if(count >= 32'd100000000) begin
		count <= 32'd0;
		if(a == 1) begin
			target_a = target_a + 1;
			if(target_a == 10) begin
				target_a <= 0;
				a <= 0;
			end
		end
		if(a == 0) begin
			target_b = target_b + 1;
			if(target_b == 10) begin
				target_b <= 0;
				a <= 1;
			end
		end
	end
end

endmodule
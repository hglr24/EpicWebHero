module hit_checker(clock, target_active, photo_array, active_is_hit);

	input clock;
	input [3:0] target_active;
	input [9:0] photo_array;
	output active_is_hit;
	reg active_hit_reg;
	assign active_is_hit = active_hit_reg;
	
	initial begin
		active_hit_reg <= 1'b0;
	end
	
	always @(posedge clock) begin
	
		if (target_active == 4'd0) begin
			active_hit_reg <= ~photo_array[0];
		end else if (target_active == 4'd1) begin
			active_hit_reg <= ~photo_array[1];
		end else if (target_active == 4'd2) begin
			active_hit_reg <= ~photo_array[2];
		end else if (target_active == 4'd3) begin
			active_hit_reg <= ~photo_array[3];
		end else if (target_active == 4'd4) begin
			active_hit_reg <= ~photo_array[4];
		end else if (target_active == 4'd5) begin
			active_hit_reg <= ~photo_array[5];
		end else if (target_active == 4'd6) begin
			active_hit_reg <= ~photo_array[6];
		end else if (target_active == 4'd7) begin
			active_hit_reg <= ~photo_array[7];
		end else if (target_active == 4'd8) begin
			active_hit_reg <= ~photo_array[8];
		end else if (target_active == 4'd9) begin
			active_hit_reg <= ~photo_array[9];
		end else begin
			active_hit_reg <= 1'b0;
		end
	end
	
endmodule

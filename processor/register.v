module register(w, clock, clr, w_en, r);

	input [31:0] w;
	input clock, clr, w_en;

	output [31:0] r;

	dffe_ref dffe_0(.q(r[0]), .d(w[0]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_1(.q(r[1]), .d(w[1]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_2(.q(r[2]), .d(w[2]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_3(.q(r[3]), .d(w[3]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_4(.q(r[4]), .d(w[4]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_5(.q(r[5]), .d(w[5]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_6(.q(r[6]), .d(w[6]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_7(.q(r[7]), .d(w[7]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_8(.q(r[8]), .d(w[8]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_9(.q(r[9]), .d(w[9]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_10(.q(r[10]), .d(w[10]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_11(.q(r[11]), .d(w[11]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_12(.q(r[12]), .d(w[12]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_13(.q(r[13]), .d(w[13]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_14(.q(r[14]), .d(w[14]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_15(.q(r[15]), .d(w[15]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_16(.q(r[16]), .d(w[16]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_17(.q(r[17]), .d(w[17]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_18(.q(r[18]), .d(w[18]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_19(.q(r[19]), .d(w[19]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_20(.q(r[20]), .d(w[20]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_21(.q(r[21]), .d(w[21]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_22(.q(r[22]), .d(w[22]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_23(.q(r[23]), .d(w[23]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_24(.q(r[24]), .d(w[24]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_25(.q(r[25]), .d(w[25]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_26(.q(r[26]), .d(w[26]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_27(.q(r[27]), .d(w[27]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_28(.q(r[28]), .d(w[28]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_29(.q(r[29]), .d(w[29]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_30(.q(r[30]), .d(w[30]), .clk(clock), .en(w_en), .clr(clr));
	dffe_ref dffe_31(.q(r[31]), .d(w[31]), .clk(clock), .en(w_en), .clr(clr));
	
endmodule

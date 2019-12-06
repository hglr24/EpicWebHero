module regfile(
	clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB,
	
	bp_write, t1hit_write, t2hit_write, t1active_read, t2active_read,
	timer1_write, timer2_write, gametimer_write, score_read
);
	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output [31:0] data_readRegA, data_readRegB;
	
	input [31:0] bp_write, t1hit_write, t2hit_write, timer1_write, timer2_write, gametimer_write;
   output [31:0] t1active_read, t2active_read, score_read;
	
	assign t1active_read = registers[4]; // always available asynchronously to rest of hardware
	assign t2active_read = registers[5];
	assign score_read = registers[9];

	reg[31:0] registers[31:0];
	
	initial begin
		integer i;
		for(i=0; i<32; i=i+1) begin
			registers[i] <= 32'b0;
		end
	end
	
	always @(posedge clock)
	begin
		if (ctrl_writeReg == 5'd4 && data_writeReg[3:0] > 4'd9) begin
			registers[4][31:4] <= data_writeReg[31:4];
			if (data_writeReg[3:0] == registers[5][3:0]) begin
				if (registers[5] == 4'd0) begin
					registers[4][3:0] <= 4'd9;
				end else begin
					registers[4][3:0] <= 4'd0;
				end
			end else begin
				registers[4][2:0] <= data_writeReg[2:0];
				registers[4][3] <= 1'b0;
			end
		end else if (ctrl_writeReg == 5'd5 && data_writeReg[3:0] > 4'd9) begin
			registers[5][31:4] <= data_writeReg[31:4];
			if (data_writeReg[3:0] == registers[4][3:0]) begin
				if (registers[4] == 4'd0) begin
					registers[5][3:0] <= 4'd9;
				end else begin
					registers[5][3:0] <= 4'd0;
				end
			end else begin
				registers[5][2:0] <= data_writeReg[2:0];
				registers[5][3] <= 1'b0;
			end
		
		end else if(ctrl_writeEnable && ctrl_writeReg != 5'd0 && ctrl_writeReg != 5'd1 && ctrl_writeReg != 5'd2 && ctrl_writeReg != 5'd3
			&& ctrl_writeReg != 5'd6 && ctrl_writeReg != 5'd7 && ctrl_writeReg != 5'd8)
			registers[ctrl_writeReg] = data_writeReg;
				
				
		registers[0] <= 32'b0;
		registers[1] <= bp_write;
		registers[2] <= t1hit_write;
		registers[3] <= t2hit_write;
		
		registers[6] <= timer1_write;
		registers[7] <= timer2_write;
		registers[8] <= gametimer_write;
	end
	
	assign data_readRegA = ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegA) ? 32'bz : registers[ctrl_readRegA];
	assign data_readRegB = ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegB) ? 32'bz : registers[ctrl_readRegB];
	
endmodule

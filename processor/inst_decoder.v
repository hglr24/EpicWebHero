module inst_decoder(inst, control_branch_neq, control_branch_lessthn, control_write_en, control_use_imm, control_data_select,
	control_storew, control_jump, control_j_jal, control_set_ex, control_branch_ex, control_read_from_rd, control_not_rtype,
	control_mult, control_div, control_rand, control_timera, control_timerb, control_timerc, control_halt);

	input [31:0] inst;
	output control_branch_neq, control_branch_lessthn, control_write_en, control_use_imm, control_data_select,
		control_storew, control_jump, control_j_jal, control_set_ex, control_branch_ex, control_read_from_rd, control_not_rtype,
		control_mult, control_div, control_rand, control_timera, control_timerb, control_timerc, control_halt;
	
	wire [4:0] opcode;
	assign opcode = inst[31:27];
	
	wire [31:0] dec_out;
	assign dec_out = 32'b1 << opcode;
	
	wire [31:0] inst_not;
	not_32bit nop_not(.in(inst), .out(inst_not));
	wire nop_inst;
	assign nop_inst = inst_not[0] && inst_not[1] && inst_not[2] && inst_not[3] && inst_not[4] && inst_not[5] && 
		inst_not[6] && inst_not[7] && inst_not[8] && inst_not[9] && inst_not[10] && inst_not[11] && inst_not[12] && 
		inst_not[13] && inst_not[14] && inst_not[15] && inst_not[16] && inst_not[17] && inst_not[18] && inst_not[19] && 
		inst_not[20] && inst_not[21] && inst_not[22] && inst_not[23] && inst_not[24] && inst_not[25] && inst_not[26] && 
		inst_not[27] && inst_not[28] && inst_not[29] && inst_not[30] && inst_not[31];
		
	wire not_nop;	
	not(not_nop, nop_inst);
	
	wire not_rtype;
	not(not_rtype, dec_out[0]);
	
	wire [4:0] alu_op;
	assign alu_op = inst[6:2];
	
	wire is_mult, is_div;
	isEqual mult_eq(.in1(alu_op), .in2(5'd6), .out(is_mult));
	isEqual div_eq(.in1(alu_op), .in2(5'd7), .out(is_div));
	
	/*
	High bit  |  Instruction
	0				add/sub/and/or/sll/sra/mul/div
	1				j
	2				bne
	3				jal
	4				jr
	5				addi
	6				blt
	7				sw
	8				lw
	21				setx
	22				bex	
	24				timera
	25				timerb
	26				timerc
	27				randn
	*/

	assign control_branch_neq = dec_out[2] && not_nop; // bne
	assign control_branch_lessthn = dec_out[6] && not_nop; // blt
	assign control_write_en = (dec_out[8] || dec_out[0] || dec_out[3] || dec_out[5] || dec_out[21] || dec_out[27]) && not_nop; // lw, aluops, jal, addi, setx, randn
	assign control_use_imm = (dec_out[5] || dec_out[7] || dec_out[8] || dec_out[21]) && not_nop; // addi, sw, lw, setx
	assign control_data_select = dec_out[8] && not_nop; // lw
	assign control_storew = dec_out[7] && not_nop; // sw
	assign control_jump = (dec_out[1] || dec_out[3] || dec_out[4]) && not_nop; // all jumps: j, jal, jr
	assign control_j_jal = (dec_out[1] || dec_out[3]) && not_nop; // j, jal
	assign control_set_ex = dec_out[21] && not_nop; // setx
	assign control_branch_ex = dec_out[22] && not_nop; // bex
	assign control_read_from_rd = (dec_out[7] || dec_out[4] || dec_out[2] || dec_out[6]) && not_nop; // sw, jr, bne, blt
	assign control_not_rtype = (not_rtype) && not_nop; // not add/sub/and/or/sll/sra/mul/div
	assign control_mult = dec_out[0] && is_mult;
	assign control_div = dec_out[0] && is_div;
	assign control_rand = dec_out[27] && not_nop; // randn
	assign control_timera = dec_out[24] && not_nop; // timera
	assign control_timerb = dec_out[25] && not_nop; // timerb
	assign control_timerc = dec_out[26] && not_nop; // timerc
	assign control_halt = dec_out[31]; // halt
	
endmodule

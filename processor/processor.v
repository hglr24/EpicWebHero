/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
	// Control signals
	clock,                          // I: The master clock
	reset,                          // I: A reset signal

	// Imem
	address_imem,                   // O: The address of the data to get from imem
	q_imem,                         // I: The data from imem

	// Dmem
	address_dmem,                   // O: The address of the data to get or put from/to dmem
	data,                           // O: The data to write to dmem
	wren,                           // O: Write enable for dmem
	q_dmem,                         // I: The data from dmem

	// Regfile
	ctrl_writeEnable,               // O: Write enable for regfile
	ctrl_writeReg,                  // O: Register to write to in regfile
	ctrl_readRegA,                  // O: Register to read from port A of regfile
	ctrl_readRegB,                  // O: Register to read from port B of regfile
	data_writeReg,                  // O: Data to write to for regfile
	data_readRegA,                  // I: Data from port A of regfile
	data_readRegB                   // I: Data from port B of regfile
	
	// TESTING
	, pc_next,
	alu_result,
	pc_curr,
	control_stall,
	control_flush,
	bypass_xm_data,
	bypass_aluinA,
	bypass_dx_regB,
	fd_inst, dx_inst, xm_inst, mw_inst,
	alu_inA, alu_inB,
	bypass_dw_regA, bypass_dw_regB, dmem_addr
	);
	
	output [11:0] pc_next, pc_curr;
	output [31:0] alu_result, dmem_addr;
	output control_stall, control_flush, bypass_xm_data, bypass_dw_regA, bypass_dw_regB;
	output [1:0] bypass_aluinA, bypass_dx_regB;
	output [31:0] fd_inst, dx_inst, xm_inst, mw_inst, alu_inA, alu_inB;
	
	// Control signals
	input clock, reset;

	// Imem
	output [11:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [11:0] address_dmem;
	output [31:0] data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;
	
	// declare multdiv
	
	wire [31:0] multdiv_result;
	wire multdiv_exception, multdiv_data_rdy;
	multdiv proc_md(.data_operandA(alu_inA), .data_operandB(alu_inB), .ctrl_MULT(control_mult && control_md_past_not && md_data_rdy_not), 
		.ctrl_DIV(control_div && control_md_past_not && md_data_rdy_not), .clock(clock), .data_result(multdiv_result), .data_exception(multdiv_exception), .data_resultRDY(multdiv_data_rdy));
		
	wire control_multdiv_past_one_cycle, control_md_past_not; // signal goes high one cycle after control_mult or control_div
	dffe_ref muldiv_sig_one_cycle(.q(control_multdiv_past_one_cycle), .d(control_mult || control_div), .en(1'b1), .clr(multdiv_data_rdy || reset), .clk(clock));
	not md_sig_not(control_md_past_not, control_multdiv_past_one_cycle);
		
	wire [31:0] arithmetic_result;
	mux_2 arithmetic_out(.in1(alu_result), .in2(multdiv_result), .select(multdiv_data_rdy && (control_mult || control_div)), .out(arithmetic_result));
	
	// while control_mult || control_div == 1 && multdiv_data_rdy == 0, STALL at fetch, decode, PC
	
	wire multdiv_stall, multdiv_stall_not, md_data_rdy_not;
	not data_rdy_not(md_data_rdy_not, multdiv_data_rdy);
	assign multdiv_stall = (control_mult || control_div) && md_data_rdy_not;
	not stall_md_not(multdiv_stall_not, multdiv_stall); // use this for w_en for various registers to STALL on multdiv
	
	// declare alu
	
	wire [31:0] alu_inA, alu_inB, alu_result;
	wire [4:0] alu_op, alu_shamt;
	wire alu_neq, alu_lessthn, alu_ovf;
	
	alu proc_alu(.data_operandA(alu_inA), .data_operandB(alu_inB), .ctrl_ALUopcode(alu_op),
			.ctrl_shiftamt(alu_shamt), .data_result(alu_result), .isNotEqual(alu_neq), .isLessThan(alu_lessthn), .overflow(alu_ovf));
			
	assign alu_inA = dx_regA_bypass;
	assign alu_shamt = dx_inst[11:7]; // these are always these values

	wire [4:0] branch_aluop;
	mux_2 alu_op_mux(.in1(dx_inst[6:2]), .in2(5'b0), .select(control_not_rtype), .out(branch_aluop)); // make aluop 0 for non r-type or branching instructions
	mux_2 alu_branch_sub(.in1(branch_aluop), .in2(5'd1), .select(control_branch_neq || control_branch_lessthn || control_bex), .out(alu_op)); // subtract if possibly branching

			
	// declare pc register
	
	wire [11:0] pc_next, pc_curr; // I/O directly from PC register
	
	wire not_ctrl_md;
	not (not_ctrl_md, control_mult || control_div);
	
	register pc_register(.w(pc_next), .clock(clock), .clr(reset), .w_en(stall_not && multdiv_stall_not /*not_ctrl_md*/), .r(pc_curr));
	assign address_imem = pc_past_md_check; // changed from pc_curr
	
	// declare stage registers
	
	wire [31:0] fd_inst, dx_inst, xm_inst, mw_inst, dx_regA, dx_regB, mw_data_out, dmem_addr, fd_inst_post_stall;
	wire [11:0] fd_pc_next, dx_pc_next, xm_pc_next, mw_pc_next, mw_addr_out;
	
	stage_register fd_register(.w1(pc_past_md_check), .w4(orig_inst_post_stall), .clock(clock), .clr(reset), .w_en(stall_not && multdiv_stall_not), .r1(fd_pc_next), .r4(fd_inst));
	stage_register dx_register(.w1(fd_pc_next), .w2(fd_regA_out), .w3(fd_regB_out), .w4(fd_inst_post_stall), .clock(clock), .clr(reset), .w_en(multdiv_stall_not), .r1(dx_pc_next), .r2(dx_regA), .r3(dx_regB), .r4(dx_inst));
	stage_register xm_register(.w1(dx_pc_next), .w2(arith_result_or_ex), .w3(dx_regB_bypass), .w4(dx_inst_post_ex), .clock(clock), .clr(reset), .w_en(multdiv_stall_not), .r1(xm_pc_next), .r2(dmem_addr), .r3(data_pre_bp_mux), .r4(xm_inst));
	stage_register mw_register(.w1(xm_pc_next), .w2(dmem_addr), .w3(q_dmem), .w4(xm_inst), .clock(clock), .clr(reset), .w_en(multdiv_stall_not), .r1(mw_pc_next), .r2(mw_addr_out_long), .r3(mw_data_out), .r4(mw_inst));
	
	assign address_dmem = dmem_addr[11:0];
	wire [31:0] mw_addr_out_long;
	
	// declare regfile register indices
	
	// always $rd except for writing to $rstatus (already changed inst previously) or $r31 (jal)
	mux_2 writeReg_mux(.in1(mw_inst[26:22]), .in2(5'd31), .select(control_j_jal_mw), .out(wreg_mux1_out));
	wire [31:0] wreg_mux1_out;
	// for setx
	mux_2 setx_mux(.in1(wreg_mux1_out), .in2(5'd30), .select(control_setx_mw), .out(ctrl_writeReg));
	
	// always $rs except for blt, when it is $rd
	mux_2 readRegAMux(.in1(fd_inst[21:17]), .in2(fd_inst[26:22]), .select(control_branch_lessthn_fd), .out(ctrl_readRegA1));
	// or bex, for which it is $rstatus
	wire [5:0] ctrl_readRegA1;
	mux_2 readRegAMux2(.in1(ctrl_readRegA1), .in2(5'd30), .select(control_bex_fd), .out(ctrl_readRegA));
	
	wire [4:0] regB_prebranch;
	// always $rt except for sw and jr, for which it is $rd, or blt, for which it is $rs
	mux_2 readRegBMux(.in1(fd_inst[16:12]), .in2(fd_inst[26:22]), .select(control_read_from_rd), .out(regB_prebranch));
	mux_2 readRegBMux2(.in1(regB_prebranch), .in2(fd_inst[21:17]), .select(control_branch_lessthn_fd), .out(ctrl_readRegB1));
	// or bex, for which it is $r0
	wire [5:0] ctrl_readRegB1;
	mux_2 readRegBMux3(.in1(ctrl_readRegB1), .in2(5'b0), .select(control_bex_fd), .out(ctrl_readRegB));
	
	// declare muxes
	
	wire [31:0] reg_data_mux_in1, data_write_prejump, reg_data_mux2_in2;
	wire reg_data_select, regB_or_imm_select;
	assign reg_data_mux2_in2[11:0] = mw_pc_next;
	
	mux_2 reg_data_mux(.in1(mw_addr_out_long), .in2(mw_data_out), .select(reg_data_select), .out(data_write_prejump));
	mux_2 data_writeReg_mux2(.in1(data_write_prejump), .in2(reg_data_mux2_in2), .select(control_j_jal_mw), .out(data_writeReg));
	
	wire [31:0] sign_ext_imm, imm_32;
	assign imm_32[31:15] = dx_inst[16:0];
	assign imm_32[14:0] = 15'b0;
	right_shift imm_shift(.data_operandA(imm_32), .ctrl_shiftamt(32'd15), .result(sign_ext_imm));
	
	mux_2 regB_or_imm_mux(.in1(dx_regB_bypass), .in2(sign_ext_imm), .select(regB_or_imm_select), .out(alu_inB));
	
	// next PC logic (happens in EXECUTE)
	
	wire blt_trig, bne_trig, bex_trig, should_branch;
	wire[31:0] jump_pc, pc_after_branch_check;
	and bneq_and(bne_trig, alu_neq, control_branch_neq);
	and blt_and(blt_trig, alu_lessthn, control_branch_lessthn);
	
	and bex_and(bex_trig, alu_neq, control_bex);
	
	or branch_or(should_branch, bne_trig, blt_trig);
	
	mux_2 next_pc_mux(.in1(pc_add_out), .in2(branch_add_out), .select(should_branch), .out(pc_after_branch_check)); // default to next PC from FETCH SCOPE
	mux_2 jump_location(.in1(dx_regB_bypass), .in2(dx_inst[26:0]), .select(control_j_jal), .out(jump_pc)); // if doing jump or jal, use T from inst	
	mux_2 next_pc_jump(.in1(pc_after_branch_check), .in2(jump_pc), .select(control_jump), .out(pc_next1));
	
	wire [11:0] pc_next1;
	
	mux_2 bex_pc_mux(.in1(pc_next1), .in2(dx_inst[26:0]), .select(bex_trig), .out(pc_next)); // bex
	
	// declare adders
	
	wire [31:0] pc_add_out, branch_add_out;
	
	add_subtract adder_pc(.data_operandA(12'd1), .data_operandB(pc_past_md_check), .subtract(1'b0), .g_in(12'd1 & pc_past_md_check), .p_in(12'd1 | pc_past_md_check), .sum(pc_add_out)); // PC + 1 word (32 bit)
	
	wire [31:0] branch_add_in1;
	assign branch_add_in1[11:0] = dx_pc_next;

	add_subtract adder_branch(.data_operandA(branch_add_in1), .data_operandB(sign_ext_imm), .subtract(1'b0), .g_in(branch_add_in1 & sign_ext_imm), .p_in(branch_add_in1 | sign_ext_imm), .sum(branch_add_out));
	
	// declare control signals
	
	wire control_branch_neq, control_branch_lessthn, control_write_en, control_use_imm, control_data_select,
		control_storew, control_jump, control_j_jal, control_set_ex, control_branch_ex, control_branch_lessthn_fd;
		
	wire control_read_from_rd, control_j_jal_mw, control_not_rtype, control_mult, control_div, control_setx_mw, control_setx, control_bex, control_bex_fd;
	
	// declare instruction decoders/control modules for each stage
	// MAKE SURE CONTROL SIGNALS ARE BEING ACCESSED AT CORRECT STAGES!!!!
	
	inst_decoder dec_fd(.inst(fd_inst), .control_read_from_rd(control_read_from_rd), .control_branch_lessthn(control_branch_lessthn_fd),
		.control_j_jal(control_j_jal_fd), .control_storew(control_storew_fd), .control_branch_ex(control_bex_fd), .control_set_ex(control_setx_fd));
	
	inst_decoder dec_dx(.inst(dx_inst), .control_branch_neq(control_branch_neq), .control_branch_lessthn(control_branch_lessthn),
		.control_use_imm(control_use_imm), .control_jump(control_jump), .control_j_jal(control_j_jal), .control_not_rtype(control_not_rtype),
		.control_read_from_rd(control_read_from_rd_dx), .control_data_select(control_data_select_dx), .control_mult(control_mult), .control_div(control_div),
		.control_set_ex(control_setx), .control_branch_ex(control_bex));
		
	inst_decoder dec_xm(.inst(xm_inst), .control_storew(control_storew), .control_branch_lessthn(control_branch_lessthn_xm), .control_j_jal(control_j_jal_xm),
		.control_read_from_rd(control_read_from_rd_xm), .control_write_en(control_write_en_xm), .control_branch_ex(control_bex_xm), .control_set_ex(control_setx_xm));
		
	inst_decoder dec_mw(.inst(mw_inst), .control_write_en(control_write_en), .control_data_select(control_data_select), .control_j_jal(control_j_jal_mw),
		.control_branch_lessthn(control_branch_lessthn_mw), .control_read_from_rd(control_read_from_rd_mw), .control_set_ex(control_setx_mw), .control_branch_ex(control_bex_mw));
		
	assign reg_data_select = control_data_select;
	assign ctrl_writeEnable = control_write_en;
	assign regB_or_imm_select = control_use_imm;
	assign wren = control_storew;
	
	// declare bypass/stall control module
	
	wire bypass_xm_data;
	wire [1:0] bypass_aluinA, bypass_dx_regB;
	wire control_read_from_rd_dx, control_j_jal_xm, control_branch_lessthn_xm, control_branch_lessthn_mw,
		control_read_from_rd_xm, control_read_from_rd_mw, control_write_en_xm, control_j_jal_fd, control_storew_fd, control_data_select_dx, control_stall,
		bypass_dw_regA, bypass_dw_regB, control_bex_xm, control_bex_mw, control_setx_fd, control_setx_xm;
	
	bypass_control b_ctrl(.fd_inst(fd_inst), .dx_inst(dx_inst), .xm_inst(xm_inst), .mw_inst(mw_inst),
	.control_j_jal_dx(control_j_jal), .control_branch_lessthn_dx(control_branch_lessthn), .control_read_from_rd_dx(control_read_from_rd_dx),
	.control_j_jal_xm(control_j_jal_xm), .control_branch_lessthn_xm(control_branch_lessthn_xm), .control_read_from_rd_xm(control_read_from_rd_xm),
	.control_j_jal_mw(control_j_jal_mw), .control_branch_lessthn_mw(control_branch_lessthn_mw), .control_read_from_rd_mw(control_read_from_rd_mw),
	.control_j_jal_fd(control_j_jal_fd), .control_branch_lessthn_fd(control_branch_lessthn_fd), .control_read_from_rd_fd(control_read_from_rd),
	.ctrl_writeEnable_xm(control_write_en_xm), .ctrl_writeEnable_mw(control_write_en), .control_storew_fd(control_storew_fd), .control_data_select_dx(control_data_select_dx),
	.control_bex_fd(control_bex_fd), .control_bex_dx(control_bex), .control_bex_xm(control_bex_xm), .control_bex_mw(control_bex_mw),
	.control_setx_fd(control_setx_fd), .control_setx_dx(control_setx), .control_setx_xm(control_setx_xm), .control_setx_mw(control_setx_mw),
	.bypass_aluinA(bypass_aluinA), .bypass_dx_regB(bypass_dx_regB), .bypass_xm_data(bypass_xm_data), .control_stall(control_stall), 
	.bypass_dw_regA(bypass_dw_regA), .bypass_dw_regB(bypass_dw_regB));
	
	// declare bypass muxes-- to DISABLE bypassing, ctrl+F for dx_regA_bypass and dx_regB_bypass and make dx_regA and dx_regB, set DMEM data in to data_pre_bp_mux
	
	wire [31:0] w_muxA1_out, w_muxA2_out;
	wire [31:0] dx_regA_bypass;
	mux_2 bypass_muxA1(.in1(dmem_addr), .in2(data_writeReg), .select(bypass_aluinA[0]), .out(w_muxA1_out));
	mux_2 bypass_muxA2(.in1(dx_regA), .in2(32'b0), .select(bypass_aluinA[0]), .out(w_muxA2_out));
	mux_2 bypass_muxA3(.in1(w_muxA1_out), .in2(w_muxA2_out), .select(bypass_aluinA[1]), .out(dx_regA_bypass));
	
	wire [31:0] w_muxB1_out, w_muxB2_out;
	wire [31:0] dx_regB_bypass;
	mux_2 bypass_muxB1(.in1(dmem_addr), .in2(data_writeReg), .select(bypass_dx_regB[0]), .out(w_muxB1_out));
	mux_2 bypass_muxB2(.in1(dx_regB), .in2(32'b0), .select(bypass_dx_regB[0]), .out(w_muxB2_out));
	mux_2 bypass_muxB3(.in1(w_muxB1_out), .in2(w_muxB2_out), .select(bypass_dx_regB[1]), .out(dx_regB_bypass));
	
	wire [31:0] data_pre_bp_mux;
	mux_2 bypass_muxMD(.in1(data_pre_bp_mux), .in2(data_writeReg), .select(bypass_xm_data), .out(data));
	
	wire [31:0] fd_regA_out, fd_regB_out;
	mux_2 bypass_muxFDA(.in1(data_readRegA), .in2(data_writeReg), .select(bypass_dw_regA), .out(fd_regA_out));
	mux_2 bypass_muxFDB(.in1(data_readRegB), .in2(data_writeReg), .select(bypass_dw_regB), .out(fd_regB_out));
	
	// declare stall logic
	
	mux_2 dx_stall_mux(.in1(fd_inst), .in2(32'b0), .select(control_stall || control_flush), .out(fd_inst_post_stall));
	
	wire stall_not;
	not (stall_not, control_stall);
	
	// declare branch recovery logic - if branch or jump is taken, flush fd, dx with nops
	
	wire control_flush, control_flush_held;
	wire [31:0] orig_inst_post_stall;
	
	assign control_flush = should_branch || control_jump || bex_trig; // either blt/bne condition fulfilled OR we're jumping
	
	mux_2 fd_stall_mux(.in1(q_imem), .in2(32'b0), .select(control_flush || control_flush_held || (multdiv_data_rdy && (control_mult || control_div))), .out(orig_inst_post_stall)); 
	
	dffe_ref flush_sig_hold(.q(control_flush_held), .d(control_flush), .en(1'b1), .clr(reset), .clk(clock));
	
	// old pc retention for multdiv fix
	
	wire [11:0] pc_old, pc_past_md_check;
	register old_pc_reg(.w(pc_past_md_check), .clr(reset), .clock(clock), .w_en(1'b1), .r(pc_old));
	mux_2 curr_pc_muxx(.in1(pc_curr), .in2(pc_old), .select(control_mult || control_div || control_stall), .out(pc_past_md_check)); //changed to include stall
	
	// declare exception checker
	
	wire is_exception;
	wire [2:0] exception_val;
	exception_checker ex_chk(.inst(dx_inst), .alu_ovf(alu_ovf), .md_ovf(multdiv_exception), .is_exception(is_exception), .exception_val(exception_val));
	
	// overwrite destination register
	
	wire [31:0] dx_inst_ex, dx_inst_post_ex;
	assign dx_inst_ex[31:27] = dx_inst[31:27];
	assign dx_inst_ex[26:22] = 5'd30;
	assign dx_inst_ex[21:0] = dx_inst[21:0];
	mux_2 dx_ex_mux(.in1(dx_inst), .in2(dx_inst_ex), .select(is_exception), .out(dx_inst_post_ex));
	
	// overwrite arithmetic result
	
	wire [31:0] arith_result_or_ex, arith_result_or_ex1;
	mux_2 alu_or_ex(.in1(arithmetic_result), .in2(exception_val), .select(is_exception), .out(arith_result_or_ex1));
	mux_2 aluex_or_setxT(.in1(arith_result_or_ex1), .in2(dx_inst[26:0]), .select(control_setx), .out(arith_result_or_ex));
	
endmodule

module bypass_control(fd_inst, dx_inst, xm_inst, mw_inst, 
	control_j_jal_dx, control_branch_lessthn_dx, control_read_from_rd_dx, 
	control_j_jal_xm, control_branch_lessthn_xm, control_read_from_rd_xm, 
	control_j_jal_mw, control_branch_lessthn_mw, control_read_from_rd_mw,
	control_j_jal_fd, control_branch_lessthn_fd, control_read_from_rd_fd,
	ctrl_writeEnable_xm, ctrl_writeEnable_mw, control_storew_fd, control_data_select_dx,
	control_bex_fd, control_bex_dx, control_bex_xm, control_bex_mw,
	control_setx_fd, control_setx_dx, control_setx_xm, control_setx_mw,
	bypass_aluinA, bypass_dx_regB, bypass_xm_data, control_stall, bypass_dw_regA, bypass_dw_regB);

	input [31:0] fd_inst, dx_inst, xm_inst, mw_inst;
	input control_j_jal_dx, control_branch_lessthn_dx, control_read_from_rd_dx, // assign these inputs from outside
		control_j_jal_xm, control_branch_lessthn_xm, control_read_from_rd_xm,
		control_j_jal_mw, control_branch_lessthn_mw, control_read_from_rd_mw,
		control_j_jal_fd, control_branch_lessthn_fd, control_read_from_rd_fd,
		control_bex_fd, control_bex_dx, control_bex_xm, control_bex_mw,
		control_setx_fd, control_setx_dx, control_setx_xm, control_setx_mw,
		ctrl_writeEnable_xm, ctrl_writeEnable_mw, control_storew_fd, control_data_select_dx;
	
	output [1:0] bypass_aluinA, bypass_dx_regB;
	output bypass_xm_data, control_stall, bypass_dw_regA, bypass_dw_regB;
	
	// determine DX regfile access values
	
	wire [4:0] ctrl_writeReg_dx, ctrl_readRegA_dx, ctrl_readRegB_dx;
	wire [4:0] ctrl_writeReg_xm, ctrl_readRegA_xm, ctrl_readRegB_xm;
	wire [4:0] ctrl_writeReg_mw, ctrl_readRegA_mw, ctrl_readRegB_mw;
	wire [4:0] ctrl_writeReg_fd, ctrl_readRegA_fd, ctrl_readRegB_fd;
	
	// always $rd except for writing to $rstatus or $r31 (jal)
	mux_2 writeReg_mux(.in1(dx_inst[26:22]), .in2(5'd31), .select(control_j_jal_dx), .out(wreg_mux1_out_dx));
	wire [31:0] wreg_mux1_out_dx;
	// for setx
	mux_2 setx_mux(.in1(wreg_mux1_out_dx), .in2(5'd30), .select(control_setx_dx), .out(ctrl_writeReg_dx));
	
	// always $rs except for blt, when it is $rd
	mux_2 readRegAMux(.in1(dx_inst[21:17]), .in2(dx_inst[26:22]), .select(control_branch_lessthn_dx), .out(ctrl_readRegA1_dx));
	// or bex, for which it is $rstatus
	wire [5:0] ctrl_readRegA1_dx;
	mux_2 readRegAMux2(.in1(ctrl_readRegA1_dx), .in2(5'd30), .select(control_bex_dx), .out(ctrl_readRegA_dx));
	
	wire [4:0] regB_prebranch_dx;
	// always $rt except for sw and jr, for which it is $rd, or blt, for which it is $rs
	mux_2 readRegBMux(.in1(dx_inst[16:12]), .in2(dx_inst[26:22]), .select(control_read_from_rd_dx), .out(regB_prebranch_dx));
	mux_2 readRegBMux2(.in1(regB_prebranch_dx), .in2(dx_inst[21:17]), .select(control_branch_lessthn_dx), .out(ctrl_readRegB1_dx));
	// or bex, for which it is $r0
	wire [5:0] ctrl_readRegB1_dx;
	mux_2 readRegBMux3(.in1(ctrl_readRegB1_dx), .in2(5'b0), .select(control_bex_dx), .out(ctrl_readRegB_dx));
	
	
	// determine XM regfile access values
	
	// always $rd except for writing to $rstatus or $r31 (jal)
	mux_2 writeReg_mux2(.in1(xm_inst[26:22]), .in2(5'd31), .select(control_j_jal_xm), .out(wreg_mux1_out_xm));
	wire [31:0] wreg_mux1_out_xm;
	// for setx
	mux_2 setx_mux22(.in1(wreg_mux1_out_xm), .in2(5'd30), .select(control_setx_xm), .out(ctrl_writeReg_xm));
	
	// always $rs except for blt, when it is $rd
	mux_2 readRegAMux25(.in1(xm_inst[21:17]), .in2(xm_inst[26:22]), .select(control_branch_lessthn_xm), .out(ctrl_readRegA1_xm));
	// or bex, for which it is $rstatus
	wire [5:0] ctrl_readRegA1_xm;
	mux_2 readRegAMux2222(.in1(ctrl_readRegA1_xm), .in2(5'd30), .select(control_bex_xm), .out(ctrl_readRegA_xm));
	
	wire [4:0] regB_prebranch_xm;
	// always $rt except for sw and jr, for which it is $rd, or blt, for which it is $rs
	mux_2 readRegBMux22(.in1(xm_inst[16:12]), .in2(xm_inst[26:22]), .select(control_read_from_rd_xm), .out(regB_prebranch_xm));
	mux_2 readRegBMux222(.in1(regB_prebranch_xm), .in2(xm_inst[21:17]), .select(control_branch_lessthn_xm), .out(ctrl_readRegB1_xm));
	// or bex, for which it is $r0
	wire [5:0] ctrl_readRegB1_xm;
	mux_2 readRegBMux3222(.in1(ctrl_readRegB1_xm), .in2(5'b0), .select(control_bex_xm), .out(ctrl_readRegB_xm));
	
	
	
	// determine MW regfile access values
	
	// always $rd except for writing to $rstatus or $r31 (jal) 
	mux_2 writeReg_mux3(.in1(mw_inst[26:22]), .in2(5'd31), .select(control_j_jal_mw), .out(wreg_mux1_out_mw));
	wire [31:0] wreg_mux1_out_mw;
	// for setx
	mux_2 setx_mux3(.in1(wreg_mux1_out_mw), .in2(5'd30), .select(control_setx_mw), .out(ctrl_writeReg_mw));
	
	// always $rs except for blt, when it is $rd
	mux_2 readRegAMux3(.in1(mw_inst[21:17]), .in2(mw_inst[26:22]), .select(control_branch_lessthn_mw), .out(ctrl_readRegA1_mw));
	// or bex, for which it is $rstatus
	wire [5:0] ctrl_readRegA1_mw;
	mux_2 readRegAMux233(.in1(ctrl_readRegA1_mw), .in2(5'd30), .select(control_bex_mw), .out(ctrl_readRegA_mw));
	
	wire [4:0] regB_prebranch_mw;
	// always $rt except for sw and jr, for which it is $rd, or blt, for which it is $rs
	mux_2 readRegBMux335(.in1(mw_inst[16:12]), .in2(mw_inst[26:22]), .select(control_read_from_rd_mw), .out(regB_prebranch_mw));
	mux_2 readRegBMux23(.in1(regB_prebranch_mw), .in2(mw_inst[21:17]), .select(control_branch_lessthn_mw), .out(ctrl_readRegB1_mw));
	// or bex, for which it is $r0
	wire [5:0] ctrl_readRegB1_mw;
	mux_2 readRegBMux3333(.in1(ctrl_readRegB1_mw), .in2(5'b0), .select(control_bex_mw), .out(ctrl_readRegB_mw));
	
	
	
	// determine outputs
	
	// ALUinA - if inst_xm writeEnable == 1 and readRegA_dx == writeReg_mw out 0, else if inst_mw writeEnable == 1 and readRegA_dx == writeReg_mw out 1, else out 2 (use orig)
	wire alu_sel_0, alu_sel_1;
	wire [4:0] check_0, check_1;	
	isEqual eq0(.in1(ctrl_readRegA_dx), .in2(ctrl_writeReg_xm), .out(check_0));
	assign alu_sel_0 = check_0 && ctrl_writeEnable_xm;
	
	isEqual eq1(.in1(ctrl_readRegA_dx), .in2(ctrl_writeReg_mw), .out(check_1));
	assign alu_sel_1 = check_1 && ctrl_writeEnable_mw;
	
	wire w_not_sel_0, w_not_sel_1;
	not (w_not_sel_0, alu_sel_0);
	not (w_not_sel_1, alu_sel_1);
	
	assign bypass_aluinA[0] = (alu_sel_1 && w_not_sel_0) ? 1'b1 : 1'b0; // output is 00 if alu_sel_0 is high, regardless of other sel signal
	assign bypass_aluinA[1] = (w_not_sel_0 && w_not_sel_1) ? 1'b1 : 1'b0;

	// dx reg B data (same logic as above)
	// if inst_xm writeEnable == 1 and readRegB_dx == writeReg_mw out 0, else if inst_mw writeEnable == 1 and readRegB_dx == writeReg_mw out 1, else out 2 (use orig)
	wire regB_sel_0, regB_sel_1;
	wire [4:0] check_regB_0, check_regB_1;
	
	isEqual eq2(.in1(ctrl_readRegB_dx), .in2(ctrl_writeReg_xm), .out(check_regB_0));
	assign regB_sel_0 = check_regB_0 && ctrl_writeEnable_xm;
	
	isEqual eq3(.in1(ctrl_readRegB_dx), .in2(ctrl_writeReg_mw), .out(check_regB_1));
	assign regB_sel_1 = check_regB_1 && ctrl_writeEnable_mw;

	wire w_not_sel_regB_0, w_not_sel_regB_1;
	not (w_not_sel_regB_0, regB_sel_0);
	not (w_not_sel_regB_1, regB_sel_1);

	assign bypass_dx_regB[0] = (regB_sel_1 && w_not_sel_regB_0) ? 1'b1 : 1'b0; // output is 00 if regB_sel_0 is high, regardless of other sel_regB signal
	assign bypass_dx_regB[1] = (w_not_sel_regB_0 && w_not_sel_regB_1) ? 1'b1 : 1'b0;
	
	// xm data - if inst_mw write_enable = 1 and writeReg_mw == readRegB_xm out 1, else out 0 (use orig)
	wire mem_data_sel;
	isEqual eq4(.in1(ctrl_readRegB_xm), .in2(ctrl_writeReg_mw), .out(mem_data_sel));	
	assign bypass_xm_data = (mem_data_sel && ctrl_writeEnable_mw) ? 1 : 0;
	
	// stall logic
	
	// determine FD register access values

	// always $rd except for writing to $rstatus or $r31 (jal) //TODO figure out $rstatus IF OVF WRITE RSTATUS NOT RD
	mux_2 writeReg_mux4(.in1(fd_inst[26:22]), .in2(5'd31), .select(control_j_jal_fd), .out(wreg_mux1_out_fd));
	wire [31:0] wreg_mux1_out_fd;
	// for setx
	mux_2 setx_mux4(.in1(wreg_mux1_out_fd), .in2(5'd30), .select(control_setx_fd), .out(ctrl_writeReg_fd));
	
	// always $rs except for blt, when it is $rd
	mux_2 readRegAMux4(.in1(fd_inst[21:17]), .in2(fd_inst[26:22]), .select(control_branch_lessthn_fd), .out(ctrl_readRegA1_fd));
	// or bex, for which it is $rstatus
	wire [5:0] ctrl_readRegA1_fd;
	mux_2 readRegAMux244(.in1(ctrl_readRegA1_fd), .in2(5'd30), .select(control_bex_fd), .out(ctrl_readRegA_fd));
	
	wire [4:0] regB_prebranch_fd;
	// always $rt except for sw and jr, for which it is $rd, or blt, for which it is $rs
	mux_2 readRegBMux4(.in1(fd_inst[16:12]), .in2(fd_inst[26:22]), .select(control_read_from_rd_fd), .out(regB_prebranch_fd));
	mux_2 readRegBMux24(.in1(regB_prebranch_fd), .in2(fd_inst[21:17]), .select(control_branch_lessthn_fd), .out(ctrl_readRegB1_fd));
	// or bex, for which it is $r0
	wire [5:0] ctrl_readRegB1_fd;
	mux_2 readRegBMux3444(.in1(ctrl_readRegB1_fd), .in2(5'b0), .select(control_bex_fd), .out(ctrl_readRegB_fd));
	
	wire stall_0, stall_1, stall_2, stall_3, stall_33;
	
	assign stall_0 = control_data_select_dx; // dx_op == lw
	isEqual eq5(.in1(ctrl_readRegA_fd), .in2(ctrl_writeReg_dx), .out(stall_1));
	isEqual eq6(.in1(ctrl_readRegB_fd), .in2(ctrl_writeReg_dx), .out(stall_2));
	assign stall_33 = control_storew_fd; // fd_op == sw
	
	not (stall_3, stall_33); // NOT a store
	
	wire writeReg_not0, writeReg_is0;
	isEqual eq66(.in1(ctrl_writeReg_dx), .in2(5'b0), .out(writeReg_is0)); // this logic overwrites stall if writeReg is $r0, since it would make no difference
	not (writeReg_not0, writeReg_is0);
	
	assign control_stall = stall_0 && (stall_1 || (stall_2 && stall_3)) && writeReg_not0;
	
	// EXTRA BYPASS DW LOGIC - if mw WE == 1 && inst_mw RD == inst_fd RS1 or RS2, BYPASS IT
	wire dw_regA_data_sel;
	isEqual eq7(.in1(ctrl_readRegA_fd), .in2(ctrl_writeReg_mw), .out(dw_regA_data_sel));
	assign bypass_dw_regA = (dw_regA_data_sel && ctrl_writeEnable_mw) ? 1 : 0;
	
	wire dw_regB_data_sel;
	isEqual eq8(.in1(ctrl_readRegB_fd), .in2(ctrl_writeReg_mw), .out(dw_regB_data_sel));
	assign bypass_dw_regB = (dw_regB_data_sel && ctrl_writeEnable_mw) ? 1 : 0;
	
	
endmodule

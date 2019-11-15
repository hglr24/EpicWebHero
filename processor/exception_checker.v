module exception_checker(inst, alu_ovf, md_ovf, is_exception, exception_val);

	input [31:0] inst;
	input alu_ovf, md_ovf;
	
	output is_exception;
	output [2:0] exception_val;
	
	wire [4:0] alu_op = inst[6:2];
	
	wire opcode_zeros, opcode_addi;
	isEqual opcode_eq(.in1(5'b0), .in2(inst[31:27]), .out(opcode_zeros));
	isEqual addiop_eq(.in1(5'd5), .in2(inst[31:27]), .out(opcode_addi));
	
	wire [31:0] dec_out;
	assign dec_out = 32'b1 << alu_op;
	
	assign is_exception = (((opcode_zeros && (dec_out[0] || dec_out[1])) || opcode_addi) && alu_ovf) ||
		((opcode_zeros && (dec_out[6] || dec_out[7])) && md_ovf);
		
	assign exception_val[0] = is_exception && opcode_zeros && (dec_out[0] || dec_out[1] || dec_out[7]);
	assign exception_val[1] = is_exception && (opcode_addi || (opcode_zeros && dec_out[1]));
	assign exception_val[2] = is_exception && opcode_zeros && (dec_out[6] || dec_out[7]);

endmodule

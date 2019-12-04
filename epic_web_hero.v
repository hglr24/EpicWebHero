module epic_web_hero (clock, reset, photo_array, flex_r, flex_l, laser_r, laser_l, target_a, target_b, 
								score_digit_a, score_digit_b, score_digit_c, score_digit_d
								
								/*, ctrl_writeEnable, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, 
								data_writeReg, data_readRegA, data_readRegB, rand_num, score, timerstartA, timerstartB, timerstartC,
								timerlengthA, timerlengthB, timerlengthC, dx_regA_bypass, timerdoneA, timerdoneB, timerdoneC, inst_mw, truelengthA, truelengthB, truelengthC*/);
								
	
  //output ctrl_writeEnable, timerstartA, timerstartB, timerstartC, timerdoneA, timerdoneB, timerdoneC;
  //output [4:0] ctrl_readRegA, ctrl_readRegB, ctrl_writeReg;
  //output [31:0] data_readRegA, data_readRegB, data_writeReg, score, timerlengthA, timerlengthB, timerlengthC, dx_regA_bypass, inst_mw, truelengthA, truelengthB, truelengthC;
  //output [3:0] rand_num;
	

	input clock, reset, flex_l, flex_r;
	input [9:0] photo_array;
	
	output laser_r, laser_l;
	
	output [3:0] target_a, target_b;	
	
	output [6:0] score_digit_a, score_digit_b, score_digit_c, score_digit_d;
	
	wire [31:0] score; // current game score
	
	/** EXT. HARDWARE INTERACTION COMPONENTS BELOW **/
	
	// declare score converter
	
	score_converter s_c(score, score_digit_a, score_digit_b, score_digit_c, score_digit_d); // D is LSD, A is MSD
	
	// declare laser drivers for each glove
	
	laser_driver right_glove_laser(.clock(clock), .in(flex_r), .out(laser_r));
	laser_driver left_glove_laser(.clock(clock), .in(flex_l), .out(laser_l));
	
	/** NEW PROCESSOR/CONTROL COMPONENTS BELOW **/
	
	wire [3:0] rand_num;
	random_num_gen ewh_rng(.score(score), .clock(clock), .ranNumTen(rand_num));
	
	wire timerdoneA, timerdoneB, timerdoneC;
	wire timerstartA, timerstartB, timerstartC;
	wire [31:0] timerlengthA, timerlengthB, timerlengthC, truelengthA, truelengthB, truelengthC;
	
	timer ewh_timer_a(.clock(clock), .timerLength(timerlengthA), .start(timerstartA), .out(timerdoneA), .length(truelengthA));
	timer ewh_timer_b(.clock(clock), .timerLength(timerlengthB), .start(timerstartB), .out(timerdoneB), .length(truelengthB));
	timer ewh_timer_c(.clock(clock), .timerLength(timerlengthC), .start(timerstartC), .out(timerdoneC), .length(truelengthC));	
	
	/** PROCESSOR COMPONENTS BELOW **/
	
	 /** IMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_imem;
    wire [31:0] q_imem;
    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address    (address_dmem),       // address of data
        .clock      (~clock),             // may need to invert the clock
        .data	     (data),    				// data you want to write
        .wren	     (wren),      			// write enable
        .q          (q_dmem)    				// data from dmem
    );

    /** REGFILE **/
    // Instantiate your regfile
    wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB,
					 bp_write, t1hit_write, t2hit_write, t1active_read, t2active_read,
					 timer1_write, timer2_write, gametimer_write, score_read;
    regfile my_regfile(
        ~clock, // CHANGED
        ctrl_writeEnable,
        1'b0, // reset
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB,
		  	
		  bp_write, t1hit_write, t2hit_write, t1active_read, t2active_read,
	     timer1_write, timer2_write, gametimer_write, score_read
    );
	 
	 assign bp_write[0] = ~reset; // inverted because button, soft reset, don't need to latch because it will see it in the game loop if held for a reasonable amount of time.
	 assign timer1_write[0] = timerdoneA;
	 assign timer2_write[0] = timerdoneB;
	 assign gametimer_write[0] = timerdoneC;
	 assign score = score_read;
	 assign target_a = t1active_read[3:0];
	 assign target_b = t2active_read[3:0];
	 
	 wire [3:0] target_a_old, target_b_old;
	 register target_a_reg(.w(target_a), .clock(clock), .clr(1'b0), .w_en(1'b1), .r(target_a_old));
	 register target_b_reg(.w(target_b), .clock(clock), .clr(1'b0), .w_en(1'b1), .r(target_b_old));
	 
	 sr_latch ta_sr(.r(target_a != target_a_old), .s(photo_array[target_a]), .q(t1hit_write[0])); // latch these until target_a, target_b change
	 sr_latch tb_sr(.r(target_b != target_b_old), .s(photo_array[target_b]), .q(t2hit_write[0]));

    /** PROCESSOR **/
    processor my_processor(
        // Control signals
        clock,                          // I: The master clock
        1'b0,                           // I: A reset signal

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
        data_readRegB,                  // I: Data from port B of regfile
		  rand_num,
		  timerstartA, timerstartB, timerstartC,
		  timerlengthA, timerlengthB, timerlengthC, dx_regA_bypass, inst_mw
	 );

endmodule

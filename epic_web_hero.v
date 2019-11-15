module epic_web_hero (clock, reset);

	/*
	PIN ASSIGNMENTS:
		Y2 - 50Mhz Clock
		M23 - Reset Button
		AB22 - GPIO[0] - Right Glove Flex Sensor
		AC15 - GPIO[1] - Right Glove Laser Enable
		AB21 - GPIO[2] - Left Glove Flex Sensor
		Y17  - GPIO[3] - Left Glove Laser Enable
		...
	*/

	input clock, reset;
	
	/** EXT. HARDWARE INTERACTION COMPONENTS BELOW **/
	
	// declare laser drivers for each glove
	
	laser_driver right_glove_laser(.clock(clock), .in(), .out()); //TODO
	laser_driver left_glove_laser(.clock(clock), .in(), .out()); //TODO
	
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
    wire [31:0] data_readRegA, data_readRegB;
    regfile my_regfile(
        ~clock, // CHANGED
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB
    );

    /** PROCESSOR **/
    processor my_processor(
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
	 );

endmodule

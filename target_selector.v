module target_selector(target_number, encode_selector);
input [3:0] target_number;	//change to 32 bit
output [3:0] encode_selector;

assign encode_selector = target_number;
endmodule
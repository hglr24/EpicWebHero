module sr_latch(r, s, q, q_not);

input r, s;
output q, q_not;

	nor nor1(q, r, q_not);
	nor nor2(q_not, s, q);

endmodule

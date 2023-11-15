module mux4busesto1bus
# (parameter width=16)
(
	input [width-1:0] w0, w1, w2, w3,
	input s0, s1,
	output[width-1:0] f
);
	
	assign f = s0 ? ( s1 ? w3 : w2 ) : ( s1 ? w1 : w0); // s0s1:11 => w3, s0s1:10 => w2, s0s1:01 => w1, s0s1:00 => w0
	
endmodule
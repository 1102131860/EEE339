//%   -a-                            %
//% f|   |b                          %
//%   -g-                            %
//% e|   |c                          %
//%   -d-                            %
//%                                  %
//% 0 1 2 3 4 5 6 7 8 9 A b C d E F  %
//%                                  %

module seg7
# (parameter digits=4)
(
	input [4*digits-1:0] bcds,
	output reg [7*digits-1:0] leds
);

	integer k;

	always @ (bcds)
		for (k=0; k<digits; k=k+1)
			case (bcds[4*k+:4])		//abcdefg or 0123456
				4'd0: leds[7*k+:7] <= ~7'b1111110;
				4'd1: leds[7*k+:7] <= ~7'b0110000;
				4'd2: leds[7*k+:7] <= ~7'b1101101;
				4'd3: leds[7*k+:7] <= ~7'b1111001;
				4'd4: leds[7*k+:7] <= ~7'b0110011;
				4'd5: leds[7*k+:7] <= ~7'b1011011;
				4'd6: leds[7*k+:7] <= ~7'b1011111;
				4'd7: leds[7*k+:7] <= ~7'b1110000;
				4'd8: leds[7*k+:7] <= ~7'b1111111;
				4'd9: leds[7*k+:7] <= ~7'b1111011;
				default: leds[7*k+:7] <= 7'bx;
			endcase
endmodule

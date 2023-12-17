//ALU Control
module ALUControl(ALUOp, FuncCode, ALUCtl);
	input [1:0] ALUOp;
	input [5:0] FuncCode;
	output [3:0] ALUCtl;
	reg [3:0] ALUCtl;
	
	always@( ALUOp, FuncCode)
	begin
		case(ALUOp)
			2'b00: ALUCtl = 4'b0010; // lw or sw: 00 -> 0010 add
			2'b01: ALUCtl = 4'b0110; // beq: 01 -> 0110 subtract
			2'b10: case(FuncCode)
						6'b 100000: ALUCtl = 4'b 0010; // add
						6'b 100010: ALUCtl = 4'b 0110; // subtract
						6'b 100100: ALUCtl = 4'b 0000; // AND
						6'b 100101: ALUCtl = 4'b 0001; // OR
						6'b 101010: ALUCtl = 4'b 0111; //set-on-less-than
						default: ALUCtl = 4'b xxxx;
					 endcase
			2'b11: ALUCtl = 4'b0000; // andi: 0000 
			default: ALUCtl = 4'b xxxx;
		endcase
	end
	
endmodule

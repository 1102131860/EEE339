// Main Controller
module Control(opcode,RegDst,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite,Jump);
	input [5:0] opcode;
	output [1:0] ALUOp;
	output RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump;
	reg [1:0] ALUOp;
	reg RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump;
	parameter R_Format = 6'b000000, LW = 6'b100011, SW = 6'b101011, BEQ=6'b000100, J = 6'b000010, Andi = 6'b001100;
	
	always @(opcode)
	begin
		case(opcode)
			R_Format:{RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp,Jump}=
				10'b 1001000100;
			LW: {RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp,Jump}=
				10'b 0111100000;
			SW: {RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp,Jump}=
				10'b x1x0010000;
			BEQ: {RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp,Jump}=
				10'b x0x0001010;
			J: {RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp,Jump}=
				10'b xxx000xxx1;
			// RegDst: don't care, ALUSrc: don't care, MemtoReg: don't care, Regwrite: None, MemRead: None, MemWrite: None, Branch: don't care, ALUOp: don't care, Jump: jump
			Andi: {RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp,Jump}=
				10'b 0101000110;
			// RegDst now becomes rt rather than rd, ALUSrc now becomes the signed offset immediate value, ALUOp now becomes (and) 4'b0000;
			default: {RegDst,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp,Jump}=
				10'b xxxxxxxxxx;
		endcase
	end
	
endmodule

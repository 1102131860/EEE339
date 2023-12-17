module MIPS1CYCLE
# (parameter data_bus_size = 32)
(clock, reset,opcode, ALUResultOut ,DReadData, X, Y, Z, T, PC);
	input clock, reset;
	output [5:0] opcode;
	output [data_bus_size-1:0] ALUResultOut,DReadData, X, Y, Z, T, PC; // For simulation purposes
	wire [1:0] ALUOp;
	wire [5:0] opcode;
	wire [data_bus_size-1:0] SignExtend,ALUResultOut,DReadData, X, Y, Z, T;
	wire RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump;
	
	// Instantiate the Datapath
	DataPath #(data_bus_size) MIPSDP (RegDst,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite,Jump,clock,reset,opcode,X,Y,Z,T,ALUResultOut,DReadData, PC);
	//Instantiate the combinational control unit
	Control MIPSControl(opcode,RegDst,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite,Jump);
	
endmodule

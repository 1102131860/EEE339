// Datapath
module DataPath
#(parameter data_bus_size = 32)
(RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump,clock, reset, opcode, X,Y,Z,T, ALUResultOut, DReadData, PC);
	input RegDst,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,Jump, clock,reset;
	input [1:0] ALUOp;
	output [5:0] opcode;
	output [data_bus_size-1:0] X,Y,Z,T, ALUResultOut, DReadData, PC;
	reg [31:0] PC, IMemory[0:31]; // this is relative to instruction, don't need to change
	wire [31:0] SignExtendOffset, PCOffset, PCValue, Instruction; // this is relative to instruction, don't need to change
	wire [data_bus_size-1:0] ALUResultOut, IAddress, DAddress, IMemOut, DmemOut, DWriteData, RWriteData, DReadData, ALUAin, ALUBin;
	wire [3:0] ALUctl;
	wire Zero;
	wire [4:0] WriteReg;
	//Instruction fields, to improve code readability
	wire [5:0] funct;
	wire [4:0] rs, rt, rd, shamt;
	wire [15:0] offset;
	wire [data_bus_size-1:0] X,Y,Z,T;
	wire [31:0] Jump_address;
	
	
	//Instantiate local ALU controller
	ALUControl alucontroller(ALUOp,funct,ALUctl);
	
	// Instantiate ALU
	MIPSALU #(data_bus_size) ALU(ALUctl, ALUAin, ALUBin, ALUResultOut, Zero);
	
	// Instantiate Register File
	RegisterFile #(data_bus_size) REG(rs, rt, WriteReg, RWriteData, RegWrite, ALUAin,DWriteData,X,Y,Z,T, clock,reset);
	
	// Instantiate Data Memory
	DataMemory #(data_bus_size) datamemory(ALUResultOut, DWriteData, MemRead, MemWrite, clock, reset, DReadData);
	
	// Instantiate Instruction Memory
	IMemory IMemory_inst(.address(PC[6:2]), .clock(clock), .q(Instruction));
	
	
	// Synthesize multiplexers
	assign WriteReg = (RegDst) ? rd : rt;
	assign ALUBin = (ALUSrc) ? SignExtendOffset : DWriteData;
	assign PCValue = (Jump) ? Jump_address : ((Branch & Zero) ? PC+4+PCOffset : PC+4);
	assign RWriteData = (MemtoReg) ? DReadData : ALUResultOut;
	
	// Acquire the fields of the R_Format Instruction for clarity
	assign {opcode, rs, rt, rd, shamt, funct} = Instruction;
	
	// Acquire the immediate field of the I_Format instructions
	assign offset = Instruction[15:0];
	//sign-extend lower 16 bits
	assign SignExtendOffset = {{16{offset[15]}} , offset[15:0]};
	// Multiply by 4 the PC offset
	assign PCOffset = SignExtendOffset << 2;
	
	// Fetch the Top 4 bits of old PC and then multiply 4 with instruction offset
	assign Jump_address = {PC[31:28], Instruction[25:0] << 2};
	
	
	// Write the address of the next instruction into the program counter
	always @(posedge clock ) 
	begin
		if (reset) 
			PC <= 32'h00000000;
		else
			PC <= PCValue;
	end
	
endmodule

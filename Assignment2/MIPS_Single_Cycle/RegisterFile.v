// MIPS single Cycle processor originaly developed for simulation by Patterson and Hennesy
// Modified for synthesis using the QuartusII package by Dr. S. Ami-Nejad. Feb. 2009
// Register File
module RegisterFile 
# (parameter data_bus_size = 32)
(Read1,Read2,Writereg,WriteData,RegWrite,Data1,Data2,X,Y,Z,T,clock,reset);
	input [4:0] Read1,Read2,Writereg; // the registers numbers to read or write
	input [data_bus_size-1:0] WriteData; // data to write
	input RegWrite; // The write control
	input clock, reset; // The clock to trigger writes
	output [data_bus_size-1:0] Data1, Data2; // the register values read;
	reg [data_bus_size-1:0] RF[31:0]; // 32 registers each 32 bits long
	integer k;
	output wire [data_bus_size-1:0] X, Y, Z, T; // to check the delay
	
	// Read from registers independent of clock
	assign Data1 = RF[Read1];
	assign Data2 = RF[Read2];
	assign X = RF[7];
	assign Y = RF[1];
	assign Z = RF[2];
	assign T = RF[3];
	// write the register with new value on the falling edge of the clock if RegWrite is high
	always @(posedge clock or posedge reset)
		if (reset) 
			for(k=0;k<data_bus_size;k=k+1) RF[k]<= 0; // Register 0 is a read only register with the content of 0
		else if (RegWrite & (Writereg!=0)) 
			RF[Writereg] <= WriteData;
			
endmodule

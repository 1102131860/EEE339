// Data Memory
module DataMemory
#(parameter data_bus_size = 32)
(Address, DWriteData, MemRead, MemWrite, clock, reset, DReadData);
	input [data_bus_size-1:0] Address, DWriteData;
	input MemRead, MemWrite, clock, reset;
	output [data_bus_size-1:0] DReadData;
	reg [data_bus_size-1:0] DMem[7:0];

	assign DReadData = DMem[Address[2:0]]; // only 8 registers in DMem
	always @(posedge clock or posedge reset)
	begin
	if (reset) 
		begin
			DMem[0]='h00000005;
			DMem[1]='h0000000A; // Y = 1
			DMem[2]='h00000055; // Z = 2, Z' = X + Y = 0x0000444E
			DMem[3]='h000000AA; // T = 3
			DMem[4]='h00005555;
			DMem[5]='h00008888;
			DMem[6]='h00550000;
			DMem[7]='h00004444; // X = 7
		end 
	else if (MemWrite) 
		DMem[Address[2:0]] <= DWriteData; // don't forget offset_address here
	end
	
	
endmodule

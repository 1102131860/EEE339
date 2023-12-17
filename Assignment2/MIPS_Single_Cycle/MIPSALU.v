//ALU
module MIPSALU 
# (parameter data_bus_size = 32)
(ALUctl, A, B, ALUOut, Zero);
	input [3:0] ALUctl;
	input [data_bus_size-1:0] A,B;
	output [data_bus_size-1:0] ALUOut;
	output Zero;
	reg [data_bus_size-1:0] ALUOut;
	
	assign Zero = (ALUOut==0); //Zero is true if ALUOut is 0
	always @(ALUctl, A, B) 
	begin //reevaluate if these change
		case (ALUctl)
			0: ALUOut <= A & B;
			1: ALUOut <= A | B;
			2: ALUOut <= A + B;
			6: ALUOut <= A - B;
			7: ALUOut <= A < B ? 1:0;
			// .... Add more ALU operations here
			default: ALUOut <= A;
		endcase
	end
	
endmodule

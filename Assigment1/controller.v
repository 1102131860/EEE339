module controller
(
	input clk, model, enable, load, reset, count_up, en_bu,
	output reg[9:0] states // [4:0] is for 59:59 model(0) enable, load, reset, count_up, en_bu [9:5] for 999.9 model (1) enable, load, reset, count_up
);

	always@(posedge clk)
	begin
		if (!model) // model 0 is 59:59
			states[4:0] <= {en_bu,count_up,reset,load,enable}; // 4:en_bu, 3:count_up, 2:reset, 1:load, 0:enable; reg[9:5] just keep the original level
		else // model 1 is 999.9 
			states[9:5] <= {en_bu,count_up,reset,load,enable}; // 9:en_bu, 8:count_up, 7:reset, 6:load, 5:enable; reg[4:0] just keep the original level
	end

endmodule
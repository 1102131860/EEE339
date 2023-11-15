module count_999
# (parameter freq=2700000, clk_count=3, flash=9000000)
(
	input clk, ent, up_down, reset, load, en_bu, // ent is enable, enc is 0.1 second clock
	input [3:0] buttons, // one input digit
	output reg ledr,
	output reg [15:0] digits, data // one output digit
);
	reg[3:0] count_1; // power(2,4) = 16 is larger than 15
	reg [10:0] count_3; // power(2,11) = 2048 is larger than 15*100 + 15*10 + 15 = 1665
	reg [25:0] count, counts_0, counts_1, counts_2, counts_3; // use to calculate the clocks to count second and buttons
	reg ten_sec, flash_time; // use to store an impulse
	reg [32:0] flash_count; // use to flash red

	always@(posedge clk)
	begin 
		count <= count < freq - 1 ? count + 1'b1 : 1'b0;
		ten_sec <= count < freq - 1 ? 1'b0 : 1'b1;
	end
	
	always @ (posedge clk) 
	begin
		if (en_bu) // 没使能按钮的话, 按按钮也没用，计数器显示按钮按下的值
		begin
			if (!buttons[0])
			begin
				counts_0 <= counts_0 + 1'b1;
				if (counts_0 >= clk_count)
				begin
					data[3:0] <= data[3:0] < 9 ? data[3:0] + 1'b1 : 4'd0;
					counts_0 <= 0; // count[3:0] clear
				end
			end
			else
				counts_0 <= 0;
			
			if (!buttons[1])
			begin
				counts_1 <= counts_1 + 1'b1;
				if (counts_1 >= clk_count)
				begin
					data[7:4] <= data[7:4] < 9 ? data[7:4] + 1'b1 : 4'd0;
					counts_1 <= 0; // counts[7:4] clear
				end
			end
			else
				counts_1 <= 0;
			
			if (!buttons[2])
			begin
				counts_2 <= counts_2 + 1'b1;
				if (counts_2 >= clk_count)
				begin
					data[11:8] <= data[11:8] < 9 ? data[11:8] + 1'b1 :4'd0;
					counts_2 <= 0; // counts[11:8] clear
				end
			end
			else
				counts_2 <= 0;
			
			if (!buttons[3])
			begin
				counts_3 <= counts_3 + 1'b1;
				if (counts_3 >= clk_count)
				begin
					data[15:12] <= data[15:12] < 9 ? data[15:12] + 1'b1 : 4'd0;
					counts_3 <= 0; // counts[15:12] clear
				end
			end
			else
				counts_3 <= 0;
		end
	end
	
	always @ (posedge clk or posedge reset)
	begin
		if (reset)
		begin
			count_1 <= 0;
			count_3 <= 0;
		end
		else if (load)
		begin
			count_1 <= data[3:0];
			count_3 <= data[15:12]*7'd100 + data[11:8]*4'd10 + data[7:4];
		end
		else if (ent && ten_sec)
		begin
			if (!up_down) // 0 is up
			begin
				count_1 <= count_1 < 9 ? count_1 + 1'b1 : 4'd0;
				if (count_1 == 9)
					count_3 <= count_3 < 999 ? count_3 + 1'b1 : 11'd0;
			end
			else // 1 is down
			begin
				count_1 <= count_1 > 0 ? count_1 - 1'b1 : 4'd9;
				if (count_1 == 0)
					count_3 <= count_3 > 0 ? count_3 - 1'b1 : 11'd999;
			end
		end
		
		digits[15:12] <= count_3/7'd100; // this is a bug here, not 4'd100 it will only be 15, power(2,7) = 128 > 100
		digits[11:8] <= (count_3/4'd10)%4'd10;
		digits[7:4] <= count_3%4'd10;
		digits[3:0] <= count_1;
	end

	always @ (posedge clk)
	begin	
		flash_count <= flash_count < 2*(flash-1) ? flash_count + 1'b1 : 0;
		flash_time <= flash_count < flash - 1 ? 1'b1 : (flash_count < 2*(flash - 1) ? 0 : 1'b1);
		if (count_3 <= data[15:12]*7'd100 + data[11:8]*4'd10 + data[7:4] 
			&& count_3 > data[15:12]*7'd100 + data[11:8]*4'd10 + data[7:4] - 3)
			ledr <= flash_time ? 1'b1 : 0;
	end
	
endmodule

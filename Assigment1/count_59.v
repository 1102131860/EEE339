module count_59
# (parameter freq = 27000000, clk_count=3, flash=9000000)
(
	input clk, ent, up_down, reset, load, en_bu, // ent is enable, en_bu is enable button
	input [3:0] buttons,
	output reg ledr,
	output reg [15:0] digits, data // divide count into two digits
);
	reg [7:0] count_minute, count_second; // power(2,8) = 256 is larger than 15*10(data_1) + 15(data_0) = 165 and count limit 59
	reg [25:0] count, counts_0, counts_1, counts_2, counts_3; // use to calculate the clocks to count one second; use to calculate impulse when buttons
	reg second, flash_time; // use to store an impulse
	reg [32:0] flash_count; // use to flash red

	always @ (posedge clk)
	begin 
		count <= count < freq - 1 ? count + 1'b1 : 1'b0;
		second <= count < freq - 1 ? 1'b0 : 1'b1;
	end
	
	always @ (posedge clk) 
	begin
		if (en_bu) // 没使能按钮的话, 按按钮也没用, 计数器显示按钮按下的值
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
					data[7:4] <= data[7:4] < 5 ? data[7:4] + 1'b1 : 4'd0;
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
					data[11:8] <= data[11:8] < 9 ? data[11:8] + 1'b1 : 4'd0;
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
					data[15:12] <= data[15:12] < 5 ? data[15:12] + 1'b1 : 4'd0;
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
			count_minute <= 0;
			count_second <= 0;
		end
		else if (load)
		begin
			count_minute <= data[15:12]*4'd10 + data[11:8];
			count_second <= data[7:4]*4'd10 + data[3:0];
		end
		else if (ent && second)
		begin
			if (!up_down) // 0 is up
			begin
				count_second <= count_second < 59 ? count_second + 1'b1 : 4'd0;
				if (count_second == 59)
					count_minute <= count_minute < 59 ? count_minute + 1'b1 : 4'd0;
			end
			else // 1 is down
			begin
				count_second <= count_second > 0 ? count_second - 1'b1 : 8'd59;
				if (count_second == 0)
					count_minute <= count_minute > 0 ? count_minute - 1'b1 : 8'd59;
			end
		end
		
		digits[15:12] <= count_minute/4'd10;
		digits[11:8] <= count_minute%4'd10;
		digits[7:4] <= count_second/4'd10;
		digits[3:0] <= count_second%4'd10;
	end
	
	always @ (posedge clk)
	begin	
		flash_count <= flash_count < 2*(flash-1) ? flash_count + 1'b1 : 0;
		flash_time <= flash_count < flash - 1 ? 1'b1 : (flash_count < 2*(flash - 1) ? 0 : 1'b1);
		if (count_minute == 0 && count_second >= 0 && count_second < 5)
			ledr <= flash_time ? 1'b1 : 0;
		if (count_minute == data[15:12]*4'd10 + data[11:8] 
			&& count_second >= data[7:4]*4'd10 + data[3:0] 
			&& count_second < data[7:4]*4'd10 + data[3:0] + 7)
			ledr <= flash_time ? 1'b1 : 0;
	end

endmodule

// This is our circuits
module digital_clock
(
	input clk, enable, count_up, reset, load, enable_bu, model, // six switches, enable, reset, load, count_up, [enable_bu, model]
	input [3:0] buttons,
	output [1:0] ledrs,
	output [27:0] led_pins
);
	parameter clk_count = 27000000, clk_count_2 = 2700000, clk_buffer = 13500000, flash=13500000;
	wire [9:0] ctr_lines; // [3:0] for model 0, [7:4] for model 1, five attributes: enable, reset, load, count_up, en_bu	
	wire [15:0] digital_0, loda_0, digital_1, loda_1, led_lines; // internal buses

	//clk,model,enable,load,reset,count_up,en_bu,states
	controller my_contol(clk,model,enable,load,reset,count_up,enable_bu,ctr_lines);
	
	//clk,ent,up_down,reset,load,en_bu,buttons,ledrs,digits,data
	count_59 #(clk_count,clk_buffer,flash) module_0(clk,ctr_lines[0],ctr_lines[3],ctr_lines[2],ctr_lines[1],ctr_lines[4],buttons,ledrs[0],digital_0,loda_0);
	count_999 #(clk_count_2,clk_buffer,flash) module_1(clk,ctr_lines[5],ctr_lines[8],ctr_lines[7],ctr_lines[6],ctr_lines[9],buttons,ledrs[1],digital_1,loda_1);
	
	//w0,w1,w2,w3,s0,s1,f; s0s1:11 => w3, s0s1:10 => w2, s0s1:01 => w1, s0s1:00 => w0
	mux4busesto1bus display_controller(digital_0,loda_0,digital_1,loda_1,model,enable_bu,led_lines);
	
	//[0]:g(6), [1]:f(5), [2]:e(4), [3]:d(3), [4]:c(2), [5]:b(1), [6]:a(0)
	seg7 segments(led_lines,led_pins);
	
endmodule

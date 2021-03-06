`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 5.10.2020 8:55:12
// Module Name: Multiple-of-three Detector FSM (test - bench)
// Project Name: Ass_4_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////


module multiple_of_three_fsm_tb;

	reg clk;
	reg rst;
	reg in;
	wire out;

	multiple_of_three_fsm uut (
		.clk(clk), 
		.rst(rst),
		.in(in),  
		.out(out)
	);

	initial begin

		clk = 0;
		rst = 1;
		in = 0;

		#200;
		
		rst = 0;
		
		in = 1;
		#20 in = 1;
		#20 in = 1;
		#20 in = 0;
		#20 in = 0;
		#20 in = 1;
		#20 in = 0;
		#20 in = 1;
		
		#10 $finish;
	end
   
	always
			#10 clk = !clk;

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 5.10.2020 8:55:12
// Module Name: Sequential GCD Calculator (test - bench)
// Project Name: Ass_4_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////

module sequential_gcd_calculator_tb;
	
	reg clock, st;
	reg [7:0] data;

	wire done, ls, gt, same, lA, lB, s1, s2, s;
	
	reg [7:0] a, b;
	
	GCD_DATAPATH DP(.less(ls), .greater(gt), .equal(same), .lA(lA), .lB(lB), .s1(s1), .s2(s2), .data(data), .clock(clock), .s(s));
	GCD_CONTROLPATH CP(.lA(lA), .lB(lB), .s1(s1), .s2(s2), .s(s), .done(done), .clock(clock), .less(ls), .greater(gt), .equal(same), .start(st));	
	
	
	initial
	    begin
		    clock = 1'b0;
		    #5 st = 1'b1;
		    #1000 $finish;
		end
	
	always #7 clock = !clock;
	initial
		begin
			#12 data = 68;  
			#10 data = 17;  
		end
		
	initial 
		begin
          $monitor($time, "  start=%b, data=%d , GCD=%d, done=%b", st, data, DP.a_out, done);
		end
endmodule
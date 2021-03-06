`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 24.09.2020 10:09:45
// Module Name: sequential binary multiplier(array multiplier)(left-shift version)
// Project Name: Ass_3_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////


module unsigned_seq_mult_LS(
		input clk,
		input rst,
		input load,
		input [5:0] a,
		input [5:0] b,
		output reg [11:0] product
    );
    
	 reg [5:0] x, y;
	 reg [3:0] cnt;
	 
	 always @(posedge clk or posedge rst) begin
		
		if(rst) begin
			x <= 0;
			y <= 0;
			cnt = 0;
			product <= 0;
		end
		
		else if(load) begin
			x <= a;
			y <= b;
			cnt = 0;
			product <= 0;
		end
		
		else if(cnt < 6) begin
			if(x[0])
				product <= product + (y << cnt);
			x <= x >> 1;
			cnt = cnt + 1;
		end
	 end
endmodule

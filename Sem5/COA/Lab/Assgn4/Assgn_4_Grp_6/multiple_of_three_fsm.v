`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 5.10.2020 8:55:12
// Module Name: Multiple-of-three Detector FSM
// Project Name: Ass_4_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////


module multiple_of_three_fsm(
		input clk,
		input rst,
		input in,
		output out
    );

	reg [1:0] s;
	assign out = (s == 0);
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)
			s <= 0;
		else
		begin
			case (s)
				0 : s <= in ? 1: 0;
				1 : s <= in ? 0: 2;
				2 : s <= in ? 2: 1;
			endcase
		end
	end
endmodule

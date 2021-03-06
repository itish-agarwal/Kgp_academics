`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Create Date: 17.09.2020 12:15:31
// Module Name: ripple_carry_adder
// Project Name: Ass_2_Grp_6
// Description: Testbench for 8-bit serial adder
// 
// Assignment 2 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////


`define CLK_CYCLE 10

module bit_serial_adder_tb();
	parameter SIZE = 8;

	reg CLK, RST, START;
	reg [SIZE-1:0] A, B;
	wire [SIZE:0] SUM;

	bit_serial_adder UUT(SUM, CLK, RST, START, A, B);

	initial begin
		CLK = 1'b0;
		forever #(`CLK_CYCLE/2) CLK = ~CLK;
	end

	initial
		$monitor("RST = %b START = %b A = %d B = %d CURRENT_STATE = %b --- SUM = %d",
			RST,
			START,
			A,
			B,
			UUT.FSM_1.CURRENT_STATE,
			SUM
		);

	initial begin
		RST = 0; START = 0; A = 'd133; B = 'd67;
		#(`CLK_CYCLE) RST = 1; START = 1;
		#(`CLK_CYCLE * 10) START = 0; A = 'd47; B = 'd53;
		#(`CLK_CYCLE * 2) START = 1;
		#(`CLK_CYCLE * 8);
	end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 24.09.2020 10:09:45
// Module Name: Sequential Unsigned Binary Multiplier (left-shift version)
// Project Name: Ass_3_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////


module unsigned_seq_mult_LS_tb;

	reg clk;
	reg rst;
	reg load;
	reg [5:0] a;
	reg [5:0] b;

	wire [11:0] product;

	unsigned_seq_mult_LS uut (
		.clk(clk), 
		.rst(rst), 
		.load(load), 
		.a(a), 
		.b(b), 
		.product(product)
	);

	initial begin
		
		clk = 0;
		rst = 1;
		load = 0;
		a = 29;
		b = 31;

		#100
        rst = 0;
		load = 1;	
		
		#20
		load = 0;
		
		#200 $finish;
	end
	
	always
		#5 clk = !clk;		
      
endmodule

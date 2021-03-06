`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 24.09.2020 10:09:45
// Module Name: Combinational Unsigned Binary Multiplier (Array Multiplier) (test-bench)
// Project Name: Ass_3_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////


module unsigned_array_mult_tb();

reg[5:0] a, b;

wire [11:0] product;

unsigned_array_mult uut(a, b, product);
initial begin
#10 a = 2; b = 3;
#10 a = 24; b = 25;
#10 a = 43; b = 11;
#10 a = 32; b = 32;
#10 a = 45; b = 45;
#10 a = 43; b = 55;
#10 a = 67; b = 9;
#5 $finish;
end 

endmodule

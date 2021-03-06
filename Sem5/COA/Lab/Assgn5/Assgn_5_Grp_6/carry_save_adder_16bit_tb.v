`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Create Date: 12.10.2020 18:15:53
// Module Name: 16-bit carry save adder (test-bench)
// Project Name: Ass_5_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////

module carry_save_adder_16bit_tb;

reg [15:0] a1, a2, a3, a4, a5, a6, a7, a8, a9;
wire [19:0] sum;

carry_save_adder_16bit uut (a1, a2, a3, a4, a5, a6, a7, a8, a9, sum);

initial begin
a1 = 0;
a2 = 0;
a3 = 0;
a4 = 0;
a5 = 0;
a6 = 0;
a7 = 0;
a8 = 0;
a9 = 0;

#20 a1=1;a2=2;a3=3;a4=4;a5=5;a6=6;a7=7;a8=8;a9=9;
#20 a1=143;a2=235;a3=343;a4=456;a5=786;a6=23;a7=71;a8=18;a9=29;
#20 a1=1242;a2=4264;a3=1253;a4=5533;a5=5948;a6=6079;a7=1029;a8=1024;a9=9999;

#10 $finish;

end  
initial
  $monitor( "a1 = %d, a2 = %d, a3 = %d, a4 = %d, a5 = %d, a6 = %d, a7 = %d, a8 = %d, a9 = %d, sum = %d", a1, a2, a3, a4, a5, a6, a7, a8, a9, sum);  
endmodule

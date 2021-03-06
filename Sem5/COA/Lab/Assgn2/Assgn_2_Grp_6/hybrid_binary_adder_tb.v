`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 18.09.2020 11:35:51
// Module Name: ripple_carry_adder
// Project Name: Ass_2_Grp_6
// Description: Testbench for 8-bit hybrid binary adder
// 
// Assignment 2 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////


module testbench;

reg[7:0] a;
reg[7:0] b;
reg cin;
wire[7:0] sum;
wire cout;

hybrid_binary_adder uut(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial
begin
#10 a=1; b=2; cin=1;
#10 a=5; b=6; cin=1;
#10 a=81; b=18; cin=1;
#10 a=200; b=152; cin=0;
#10 a=46; b=34; cin=1;
#10 a=12; b=2; cin=1;
#10 a=81; b=18; cin=1;
#10 a=35; b=15; cin=0;
#10 a=26; b=7; cin=1;
#10 a=34; b=78; cin=0;
#10 a=9; b=5; cin=1;

#5 $finish;
end

endmodule

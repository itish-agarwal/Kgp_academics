`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Create Date: 18.09.2020 08:39:56
// Module Name: ripple_carry_adder_tb
// Project Name: Ass_2_Grp_6
// Description: Ripple Carry Adder testbench
// 
// Assignment 2 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////


module ripple_carry_adder_tb;

reg[7:0] a;
reg[7:0] b;
reg cin;
wire[7:0] sum;
wire cout;

ripple_carry_adder uut(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial
begin
#10 a=1; b=2; cin=1;
#10 a=81; b=18; cin=1;
#10 a=35; b=45; cin=0;
#10 a=56; b=7; cin=1;
#10 a=34; b=78; cin=0;
#10 a=29; b=9; cin=0;
#10 a=44; b=13; cin=1;
#10 a=70; b=19; cin=0;
#10 a=9; b=5; cin=1;

#5 $finish;
end

endmodule

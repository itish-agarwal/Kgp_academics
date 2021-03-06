`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 18.09.2020 08:39:56
// Module Name: ripple_carry_adder
// Project Name: Ass_2_Grp_6
// Description: Create a 8-bit ripple carry adder using 8 full adders
// 
// Assignment 2 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////

module full_adder(x, y, cin, s, cout);
    input x, y, cin;
    output s, cout;
    
    assign s = (x ^ y ^ cin);
    assign cout = ((x&y) | (x&cin) | (y&cin));
endmodule
module ripple_carry_adder(input [7:0] a, input [7:0] b, input cin, output [7:0] sum, output cout);
    
    //define a wire to store carry output;
    wire[6:0] carry;
    //now call full adders one by one to store results in sum and carry;
    full_adder ret1(a[0], b[0], cin, sum[0], carry[0]);
    full_adder ret2(a[1], b[1], carry[0], sum[1], carry[1]);
    full_adder ret3(a[2], b[2], carry[1], sum[2], carry[2]);
    full_adder ret4(a[3], b[3], carry[2], sum[3], carry[3]);
    full_adder ret5(a[4], b[4], carry[3], sum[4], carry[4]);
    full_adder ret6(a[5], b[5], carry[4], sum[5], carry[5]);
    full_adder ret7(a[6], b[6], carry[5], sum[6], carry[6]);
    full_adder ret8(a[7], b[7], carry[6], sum[7], cout);
    
endmodule



`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Create Date: 12.10.2020 8:10:23
// Module Name: 16-bit carry select adder (test-bench)
// Project Name: Ass_5_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////

// 2 x 1 Multiplexer
 
module mux(in0, in1, s, out);

parameter w = 16; 

input [w-1:0] in0, in1;
input s;
output [w-1:0] out;
assign out=(s)?in1:in0;

endmodule

// 1 bit Half Adder
 
module half_adder( a,b, sum, cout );

input a,b;
output sum, cout;
xor p1 (sum,a,b);
and p2 (cout,a,b);

endmodule

// 1 bit Full Adder
 
module full_adder(a, b, cin, sum, cout);

input a,b,cin;
output sum, cout;
wire w1, w2, w3;
 
half_adder h1(.a(a), .b(b), .sum(w1), .cout(w2));
half_adder h2(.a(w1), .b(cin), .sum(sum), .cout(w3));
or o1(cout, w3, w2);

endmodule

//4-bit Ripple Carry Adder

module ripple_carry_4bit(a, b, cin, sum, cout);

input [3:0] a,b;
input cin;
output [3:0] sum;
output cout;
 
wire c1,c2,c3;
 
full_adder fa1(.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c1));
full_adder fa2( .a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]), .cout(c2));
full_adder fa3( .a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]), .cout(c3));
full_adder fa4( .a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]), .cout(cout));

endmodule

// 4-bit Carry Select Adder
 
module carry_select_adder_4bit(a, b, cin, sum, cout);

input [3:0] a,b;
input cin;
output [3:0] sum;
output cout;
 
wire [3:0] s0,s1;
wire c0,c1;
 
ripple_carry_4bit r1(.a(a[3:0]), .b(b[3:0]), .cin(1'b0), .sum(s0[3:0]), .cout(c0));
ripple_carry_4bit r2(.a(a[3:0]), .b(b[3:0]), .cin(1'b1), .sum(s1[3:0]), .cout(c1));
 
mux #(4) m1(.in0(s0[3:0]), .in1(s1[3:0]), .s(cin), .out(sum[3:0]));
mux #(1) m2(.in0(c0), .in1(c1), .s(cin), .out(cout));

endmodule

// 16-bit carry select adder

module carry_select_adder_16bit(a, b, cin, sum, cout);

input [15:0] a,b;
input cin;
output [15:0] sum;
output cout;
 
wire [2:0] carry;
 
ripple_carry_4bit rca1(.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(carry[0]));
 
carry_select_adder_4bit s(.a(a[7:4]), .b(b[7:4]), .cin(carry[0]), .sum(sum[7:4]), .cout(carry[1]));
carry_select_adder_4bit s2(.a(a[11:8]), .b(b[11:8]), .cin(carry[1]), .sum(sum[11:8]), .cout(carry[2]));
carry_select_adder_4bit s3(.a(a[15:12]), .b(b[15:12]), .cin(carry[2]), .sum(sum[15:12]), .cout(cout));

endmodule


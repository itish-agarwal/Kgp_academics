`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Create Date: 12.10.2020 14:35:47
// Module Name: 16-bit carry save adder
// Project Name: Ass_5_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////

module fulladder(a, b, cin, sum, cout);

input a,b,cin;
output sum, cout;

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (cin & b) | (a & cin);

endmodule

module csa(x, y, z, s);

input [19:0] x, y, z;
output [19:0] s;
wire [19:0] c1,s1,c2;

fulladder f1 (x[0],y[0],z[0],s1[0],c1[0]);
fulladder f2 (x[1],y[1],z[1],s1[1],c1[1]);
fulladder f3 (x[2],y[2],z[2],s1[2],c1[2]);
fulladder f4 (x[3],y[3],z[3],s1[3],c1[3]); 
fulladder f5 (x[4],y[4],z[4],s1[4],c1[4]); 
fulladder f6 (x[5],y[5],z[5],s1[5],c1[5]); 
fulladder f7 (x[6],y[6],z[6],s1[6],c1[6]); 
fulladder f8 (x[7],y[7],z[7],s1[7],c1[7]); 
fulladder f9 (x[8],y[8],z[8],s1[8],c1[8]); 
fulladder f10 (x[9],y[9],z[9],s1[9],c1[9]); 
fulladder f11 (x[10],y[10],z[10],s1[10],c1[10]); 
fulladder f12 (x[11],y[11],z[11],s1[11],c1[11]); 
fulladder f13 (x[12],y[12],z[12],s1[12],c1[12]);
fulladder f14 (x[13],y[13],z[13],s1[13],c1[13]);
fulladder f15 (x[14],y[14],z[14],s1[14],c1[14]);
fulladder f16 (x[15],y[15],z[15],s1[15],c1[15]);
fulladder f17 (x[16],y[16],z[16],s1[16],c1[16]);
fulladder f18 (x[17],y[17],z[17],s1[17],c1[17]);
fulladder f19 (x[18],y[18],z[18],s1[18],c1[18]);
fulladder f20 (x[19],y[19],z[19],s1[19],c1[19]);

fulladder fa1 (s1[1],c1[0],1'b0,s[1],c2[1]);
fulladder fa2 (s1[2],c1[1],c2[1],s[2],c2[2]);
fulladder fa3 (s1[3],c1[2],c2[2],s[3],c2[3]);
fulladder fa4 (s1[4],c1[3],c2[3],s[4],c2[4]);
fulladder fa5 (s1[5],c1[4],c2[4],s[5],c2[5]);
fulladder fa6 (s1[6],c1[5],c2[5],s[6],c2[6]);
fulladder fa7 (s1[7],c1[6],c2[6],s[7],c2[7]);
fulladder fa8 (s1[8],c1[7],c2[7],s[8],c2[8]);
fulladder fa9 (s1[9],c1[8],c2[8],s[9],c2[9]);
fulladder fa10 (s1[10],c1[9],c2[9],s[10],c2[10]);
fulladder fa11 (s1[11],c1[10],c2[10],s[11],c2[11]);
fulladder fa12 (s1[12],c1[11],c2[11],s[12],c2[12]);
fulladder fa13 (s1[13],c1[12],c2[12],s[13],c2[13]);
fulladder fa14 (s1[14],c1[13],c2[13],s[14],c2[14]);
fulladder fa15 (s1[15],c1[14],c2[14],s[15],c2[15]);
fulladder fa16 (s1[16],c1[15],c2[15],s[16],c2[16]);
fulladder fa17 (s1[17],c1[16],c2[16],s[17],c2[17]);
fulladder fa18 (s1[18],c1[17],c2[17],s[18],c2[18]);
fulladder fa19 (s1[19],c1[18],c2[18],s[19],c2[19]);

assign s[0] = s1[0];

endmodule

module carry_save_adder_16bit(a1, a2, a3, a4, a5, a6, a7, a8, a9, sum);

input [15:0] a1, a2, a3, a4, a5, a6, a7, a8, a9;
output [19:0] sum;
wire [19:0] s1, s2, s3;

csa x1 ({4'b0000, a1}, {4'b0000, a2}, {4'b0000, a3}, s1);
csa x2 (s1, {4'b0000, a4}, {4'b0000, a5}, s2);
csa x3 (s2, {4'b0000, a6}, {4'b0000, a7}, s3);
csa x4 (s3, {4'b0000, a8}, {4'b0000, a9}, sum);

endmodule

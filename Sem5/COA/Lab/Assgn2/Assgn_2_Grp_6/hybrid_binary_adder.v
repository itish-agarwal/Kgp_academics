`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 18.09.2020 11:35:51
// Module Name: ripple_carry_adder
// Project Name: Ass_2_Grp_6
// Description: 8-bit hybrid binary adder
// 
// Assignment 2 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////


module four_bit_CLA_Adder(
    input [3:0] a,
    input [3:0] b,
    input cy_in,
    output [3:0] sum,
    output cy_out
    );
	 
	 wire [3:0] G;
	 wire [3:0] P;
	 wire [3:0] cout;
	 
	 assign G[0]=(a[0] & b[0]);
	 assign G[1]=(a[1] & b[1]);
	 assign G[2]=(a[2] & b[2]);
	 assign G[3]=(a[3] & b[3]);
	 	
	 assign P[0]=(a[0] ^ b[0]);
	 assign P[1]=(a[1] ^ b[1]);
	 assign P[2]=(a[2] ^ b[2]);
	 assign P[3]=(a[3] ^ b[3]);
	 
	 assign cout[0]=(G[0] | (P[0] & cy_in));
	 assign cout[1]=((G[1]) | (G[0] & P[1]) | (cy_in & P[0] & P[1]));
	 assign cout[2]=((G[2]) | (G[1] & P[2]) | (G[0] & P[1] & P[2]) | (cy_in & P[0] & P[1] & P[2]));
	 assign cout[3]=((G[3]) | (G[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[0] & P[1] & P[2] & P[3]) | (cy_in & P[0] & P[1] & P[2] & P[3]));
	 
	 assign cy_out=cout[3];

	 assign sum[0]=P[0] ^ cy_in;	
	 assign sum[1]=P[1] ^ cout[0];		
	 assign sum[2]=P[2] ^ cout[1];		
	 assign sum[3]=P[3] ^ cout[2];		
endmodule

module hybrid_binary_adder(a,b,cin,sum,cout);

  input[7:0] a,b;
  input cin;
  output [7:0] sum;
  output cout;
  wire p1,p2;
  four_bit_CLA_Adder A1(.a(a[3:0]), .b(b[3:0]), .cy_in(cin), .sum(sum[3:0]), .cy_out(p1));
  four_bit_CLA_Adder A2(.a(a[7:4]), .b(b[7:4]), .cy_in(p1), .sum(sum[7:4]), .cy_out(p2));
  assign cout = p2;
  
endmodule

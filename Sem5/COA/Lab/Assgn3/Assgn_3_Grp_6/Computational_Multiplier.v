`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 24.09.2020 10:09:45
// Module Name: Combinational Unsigned Binary Multiplier (Array Multiplier)
// Project Name: Ass_3_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////

// Half Adder
module HA(sum, cout, a, b);
	input a,b;
	output sum, cout;

	assign sum=a ^ b;
	assign cout=a & b;

endmodule

// Full Adder
module FA(sum, cout, a, b, cin);
	input a,b,cin;
	output sum,cout;

	assign sum=a^ b ^ cin;
	assign cout=(a & b)|(a & cin)|(b & cin);

endmodule

// Combinational Multiplier
module unsigned_array_mult(input [5:0] a, input [5:0] b, output [11:0] product);

    wire [29:0] c;
    wire [19:0] sum;
	wire [35:0] mult;
	

	and m00( mult[0], a[0], b[0] );
	and m01( mult[1], a[0], b[1] );
	and m02( mult[2], a[0], b[2] );
	and m03( mult[3], a[0], b[3] );
	and m04( mult[4], a[0], b[4] );
	and m05( mult[5], a[0], b[5] );
	and m06( mult[6], a[1], b[0] );
	and m07( mult[7], a[1], b[1] );
	and m08( mult[8], a[1], b[2] );
	and m09( mult[9], a[1], b[3] );
	and m10( mult[10], a[1], b[4] );
	and m11( mult[11], a[1], b[5] );
	and m12( mult[12], a[2], b[0] );
	and m13( mult[13], a[2], b[1] );
	and m14( mult[14], a[2], b[2] );
	and m15( mult[15], a[2], b[3] );
	and m16( mult[16], a[2], b[4] );
	and m17( mult[17], a[2], b[5] );
	and m18( mult[18], a[3], b[0] );
	and m19( mult[19], a[3], b[1] );
	and m20( mult[20], a[3], b[2] );
	and m21( mult[21], a[3], b[3] );
	and m22( mult[22], a[3], b[4] );
	and m23( mult[23], a[3], b[5] );
	and m24( mult[24], a[4], b[0] );
	and m25( mult[25], a[4], b[1] );
	and m26( mult[26], a[4], b[2] );
	and m27( mult[27], a[4], b[3] );
	and m28( mult[28], a[4], b[4] );
	and m29( mult[29], a[4], b[5] );
	and m30( mult[30], a[5], b[0] );
	and m31( mult[31], a[5], b[1] );
	and m32( mult[32], a[5], b[2] );
	and m33( mult[33], a[5], b[3] );
	and m34( mult[34], a[5], b[4] );
	and m35( mult[35], a[5], b[5] );

	assign product[0]=mult[0];

	HA h1( product[1], c[0], mult[1], mult[6]);
	
	FA f1( sum[0], c[1], mult[7], mult[12], c[0]);
	FA f2( sum[1], c[2], mult[18], mult[13], c[1]);
	FA f3( sum[2], c[3], mult[24], mult[19], c[2]);
	FA f4( sum[3], c[4], mult[30], mult[25], c[3]);

	HA h2( product[2], c[5], sum[0], mult[2]);
	
	FA f5( sum[4], c[6], sum[1], mult[8], c[5]);
	FA f6( sum[5], c[7], sum[2], mult[14], c[6]);
	FA f7( sum[6], c[8], sum[3], mult[20], c[7]);
	FA f8( sum[7], c[9], c[4], mult[31], c[8]);

	HA h3( product[3], c[10], sum[4], mult[3]);
	
	FA f9( sum[8], c[11], sum[5], mult[9], c[10]);
	FA f10( sum[9], c[12], sum[6], mult[15], c[11]);
	FA f11( sum[10], c[13], sum[7], mult[26], c[12]);
	FA f12( sum[11], c[14], c[9], mult[32], c[13]);

	HA h4( product[4], c[15], sum[8], mult[4]);
	
	FA f13( sum[12], c[16], sum[9], mult[10], c[15]);
	FA f14( sum[13], c[17], sum[10], mult[21], c[16]);
	FA f15( sum[14], c[18], sum[11], mult[27], c[17]);
	FA f16( sum[15], c[19], c[14], mult[33], c[18]);

	HA h5( product[5], c[20], sum[12], mult[5]);
	
	FA f17( sum[16], c[21], sum[13], mult[16], c[20]);
	FA f18( sum[17], c[22], sum[14], mult[22], c[21]);
	FA f19( sum[18], c[23], sum[15], mult[28], c[22]);
	FA f20( sum[19], c[24], c[19], mult[34], c[23]);

	HA h6( product[6], c[25], sum[16], mult[11]);
	
	FA f21( product[7], c[26], sum[17], mult[17], c[25]);
	FA f22( product[8], c[27], sum[18], mult[23], c[26]);
	FA f23( product[9], c[28], sum[19], mult[29], c[27]);
	FA f24( product[10], c[29], c[24], mult[35], c[28]);

	assign product[11]=c[29];

endmodule

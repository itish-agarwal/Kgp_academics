`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Create Date: 12.10.2020 10:09:45
// Module Name: 16-bit carry select adder (test-bench)
// Project Name: Ass_5_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////

module carry_select_adder_16bit_tb;

reg [15:0] a,b;
reg cin;
wire [15:0] sum;
wire cout;
 
carry_select_adder_16bit uut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
 
initial begin

  a=0;
  b=0;
  cin=0;
  
  #20 a=16'd2; b=16'd0; cin=1'd1;
  #20 a=16'd14; b=16'd48; cin=1'd0;
  #20 a=16'd124; b=16'd857; cin=1'd0;
  #20 a=16'd7786; b=16'd3302; cin=1'd1;
  #20 a=16'd20495; b=16'd31259; cin=1'd0;
  #20 a=16'd19999; b=16'd59302; cin=1'd1;
  
  #10 $finish;
  
end
 
initial
  $monitor( "a = %d, b = %d, cin = %d, sum = %d, cout = %d", a,b,cin,sum,cout);
endmodule

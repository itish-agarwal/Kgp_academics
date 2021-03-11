`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Create Date: 12.10.2020 14:35:47
// Module Name: 4-bit Arithmetic Logic Unit
// Project Name: Ass_5_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////

module ALU4bitTB();
  
  reg [3:0] A,B,S;
  reg M,cin;
  
  wire [3:0] F;
  wire cout, is_equal;
 
  ALU4bit uut(
    .A(A),  
    .B(B),  
    .Select(S),  
    .Mode(M),  
    .F(F),  
    .cin(cin),  
    .cout(cout), 
    .isEqual(is_equal)
  );
      
  
  initial
    begin
    
      $monitor("A = %d, B = %d, S = %d, M = %d,\t F = %d, cout=%d", A, B, S, M, F, cout);
    
    cin = 1;
      
    #0  A=4'b0111; B=4'b0011; S = 4'b0000; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b0001; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b0010; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b0011; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b0100; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b0111; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b0110; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b0111; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b1000; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b1001; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b1010; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b1011; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b1100; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b1101; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b1110; M = 0;
    #10 A=4'b0111; B=4'b0011; S = 4'b1111; M = 0;
    
    #10 A=4'b0111; B=4'b0011; S = 4'b0000; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b0001; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b0010; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b0011; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b0100; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b0111; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b0110; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b0111; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b1000; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b1001; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b1010; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b1011; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b1100; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b1101; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b1110; M = 1;
    #10 A=4'b0111; B=4'b0011; S = 4'b1111; M = 1;
    
    #50 $finish;
  end   

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 5.10.2020 8:55:12
// Module Name: Sequential GCD Calculator
// Project Name: Ass_4_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////


module need(output reg [7:0] result, input [7:0] a, input l, input clock);
  always @(posedge clock)
      if(l)
      result <= a;
endmodule

module mux(output [7:0] result, input [7:0] a, input [7:0] b, input s);
  assign result = s ? b : a;
endmodule

module compare(output less, output equal, output greater, input [7:0] x, input [7:0] y);
  assign less = (x < y);
  assign greater = (x > y);
  assign equal = (x == y);
endmodule

module subtract(output reg [7:0] out, input [7:0] a, input [7:0] b);
  always @(*)
    out = a - b;
endmodule

module GCD_DATAPATH(output less, output greater, output equal, input lA, input lB, input s1, input s2, input clock, input [7:0] data, input s);
  wire [7:0] a_out, b_out, x, y, t, cout;
  
  need R1 (.result(a_out), .a(t), .l(lA), .clock(clock));
  need R2 (.result(b_out), .a(t), .l(lB), .clock(clock));
  mux m1 (.result(x), .a(a_out), .b(b_out), .s(s1));
  mux m2 (.result(y), .a(a_out), .b(b_out), .s(s2));
  mux m3 (.result(t), .a(cout), .b(data), .s(s));
  subtract Sub (.out(cout), .a(x), .b(y));
  compare Comp (.less(less), .greater(greater), .equal(equal), .x(a_out), .y(b_out));

endmodule

module GCD_CONTROLPATH(output reg lB, output reg lA, output reg s2, output reg s1, output reg s, output reg done, input clock, input less, input equal, input greater, input start);

  reg [2:0] S;
  
  parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101;
  
  always @(posedge clock)
      begin
        case(S)
        S0:    if(start)  S <= S1;
        S1:    S <= S2;
        S2:    #2 if(equal)  S <= S5;
             else if(less)  S <= S3;
             else if(greater)  S <= S4;
        S3:    #2 if(equal)  S <= S5;
             else if(less)  S <= S3;
             else if(greater)  S <= S4;
        S4:    #2 if(equal)  S <= S5;
             else if(less)  S <= S3;
             else if(greater)  S <= S4;
        S5:    S <= S5;
        default:  S <= S0;
      endcase
    end
    
  always @(S)
    begin
      case(S)
        S0:    begin s = 1;  lA = 1; lB = 0; done = 0;  end 
        S1:    begin s = 1;  lA = 0; lB = 1; end
        S2:    if(equal)  done = 1;
             else if(less)  begin
                    s1 = 1;  s2 = 0; s = 0;
                    #1 lA = 0; lB = 1;
                    end 
             else if(greater)  begin
                       s1 = 0;  s2 = 1; s = 0;
                       #1 lA = 1; lB = 0;
                       end 
        S3:    if(equal)  done = 1;
             else if(less)  begin
                    s1 = 1;  s2 = 0; s = 0;
                    #1 lA = 0; lB = 1;
                    end 
             else if(greater)  begin
                       s1 = 0;  s2 = 1; s = 0;
                       #1 lA = 1; lB = 0;
                       end 
        S4:    if(equal)  done = 1;
             else if(less)  begin
                    s1 = 1;  s2 = 0; s = 0;
                    #1 lA = 0; lB = 1;
                    end 
             else if(greater)  begin
                       s1 = 0;  s2 = 1; s = 0;
                       #1 lA = 1; lB = 0;
                       end 
        S5:    begin
               done = 1;  s1 = 0; s2 = 0; lA = 0;
             lB = 0;
             end
        default: begin  lA = 0; lB = 0;  end
      endcase
    end 
endmodule
module MUX_test;
  reg [15:0] x;
  reg [3:0] s;
  wire z;
  mux_16x1 M1(.out(z), .a0(x[0]) ,.a1(x[1]) ,.a2(x[2]), .a3(x[3]) ,.a4(x[4]) ,.a5(x[5]), .a6(x[6]) ,.a7(x[7]) ,.a8(x[8]), .a9(x[9]) ,.a10(x[10]) ,.a11(x[11]), .a12(x[12]) ,.a13(x[13]) ,.a14(x[14]), .a15(x[15]), .x0(s[0]) ,.x1(s[1]) ,.x2(s[2]), .x3(s[3]));
   initial
     begin
       $display("S3 S2 S1 S0  \t d15 d14 d13 d12 d11 d10 d9 d8 d7 d6 d5 d4 d3 d2 d1 d0 \t Y");
       $monitor("%b  %b  %b  %b \t %b   %b   %b   %b   %b   %b   %b  %b  %b  %b  %b  %b  %b  %b  %b  %b\t %b", s[3], s[2], s[1], s[0], x[15], x[14], x[13], x[12], x[11], x[10], x[9], x[8], x[7], x[6], x[5], x[4], x[3], x[2], x[1], x[0], z);
      x = 16'h0001; s = 4'b0000;
      #10 x = 16'h0040; s = 4'b0110;
      #10 x = 16'h0080; s = 4'b0111;
      #10 x = 16'h0100; s = 4'b1000;
      #10 x = 16'h0200; s = 4'b1001;
      #10 x = 16'h0400; s = 4'b1010;
      #10 x = 16'h0800; s = 4'b1011;
     
      #10 $finish;
    end
endmodule

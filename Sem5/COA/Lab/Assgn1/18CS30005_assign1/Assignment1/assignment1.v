module mux_2x1(output out, input a, input b, input x);
	assign out = x ? b : a;
endmodule

module mux_4x1(output out, input a0,a1,a2,a3,x0,x1);
	wire w1,w2;
	mux_2x1 M0(.out(t1),.a(a0),.b(a1),.x(x0));
	mux_2x1 M1(.out(t2),.a(a2),.b(a3),.x(x0));
	mux_2x1 M2(.out(out),.a(w1),.b(w2),.x(x1));
endmodule

module mux_8x1(out,a0,a1,a2,a3,a4,a5,a6,a7,x0,x1,x2);
	input a0,a1,a2,a3,a4,a5,a6,a7,x0,x1,x2;
	output out;
	wire w1,w2;
	mux_4x1 M0(.out(t1),.a0(a),.a1(b),.a2(c),.a3(d),.x0(x0),.x1(x1));
	mux_4x1 M1(.out(t2),.a0(e),.a1(f),.a2(g),.a3(h),.x0(x0),.x1(x1));
	mux_2x1 M2(.out(out),.a(w1),.b(w2),.x(x2));
endmodule

module mux_16x1(out,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,x0,x1,x2,x3);
	input a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,x0,x1,x2,x3;
	output out;
	wire w1,w2;
	mux_8x1 M0(.out(t1),.a0(a0),.a1(a1),.a2(a2),.a3(a3),.a4(a4),.a5(a5),.a6(a6),.17(a7),.x0(x0),.x1(x1),.x2(x2));
	mux_8x1 M1(.out(t2),.a0(a8),.a1(a9),.a2(a10),.a3(a11),.a4(a12),.a5(a13),.a6(a14),.a7(a15),.x0(x0),.x1(x1),.x2(x2));
	mux_2x1 M2(.out(out),.a(w1),.b(w2),.x(x3));
endmodule

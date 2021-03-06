`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 24.09.2020 10:09:45
// Module Name: Sequential Unsigned Binary Multiplier (right-shift version)
// Project Name: Ass_3_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////


module unsigned_seq_mult_RS(
	input  clk,
	input  rst,
	input load,
	input [5:0] a,
	input [5:0] b,
	output reg [12:0] product
	);
	
	reg [5:0] x, y;
	reg [2:0] cnt;					
	reg [12:0] temp;					
											
	
	always @ (posedge clk or posedge rst) begin 
		
		if(rst) begin				
			cnt = 0;
			product <= 0;		
			x <= 0;
			y <= 0;
		end

		else if(load) begin	
		    cnt = 0;
			product <= 0;		
			x <= a;
			y <= b;
		end
			
		else if(cnt < 6) begin		
		
			if( x[0])			
				temp = y << 6;
				
			else
				temp = 0;	
			x <= x >> 1;				
			cnt = cnt + 1;						
			product <= (product + temp) >> 1;  
									
		end
	end
endmodule

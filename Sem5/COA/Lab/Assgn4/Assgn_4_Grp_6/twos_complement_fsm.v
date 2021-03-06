`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 5.10.2020 8:55:12
// Module Name: Two’s Complement Converter FSM
// Project Name: Ass_4_Grp_6
// 
// Assignment 3 - COA Lab
// GROUP 6
// 18CS30005 - Aditya Singh
// 18CS30021 - Itish Agarwal
//////////////////////////////////////////////////////////////////////////////////


module twos_complement_fsm(
		input clk,
		input rst,
		input in,
		output reg out
    );

	reg s;
	
	always @(posedge clk or posedge rst)
	begin
		if(rst) begin
		    out <= 0;
			s <= 0;
		end
		else begin
		    case (s)
				0 : begin 
				    if (in == 0) begin
				        out <= 0;
				        s <= 0;
				    end
				    else begin
				        out <= 1;
				        s <= 1;
				    end
				end
				1 : begin 
				    if (in == 0) begin
				        out <= 1;
				        s <= 1;
				    end
				    else begin
				        out <= 0;
				        s <= 1;
				    end
				end
			endcase
		end
	end
endmodule

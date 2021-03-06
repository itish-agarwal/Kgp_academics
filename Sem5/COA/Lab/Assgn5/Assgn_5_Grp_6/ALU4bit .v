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

module CarryLookAhead4bit(input [3:0] x, input [3:0] y, input cin, output [3:0] sum, output cout);

  wire [3:0] P, G, C;

  assign P = x^y;
  assign G = x&y;

  assign C[0] = G[0] | (P[0] & cin);
  assign C[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
  assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & cin);
  assign cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & cin);

  assign sum[0] = (P[0]^cin);
  assign sum[1] = (P[1]^C[0]);
  assign sum[2] = (P[2]^C[1]);
  assign sum[3] = (P[3]^C[2]);

endmodule


module ALU4bit(input [3:0] A,input [3:0] B, input [3:0] Select, input cin, input Mode, output [3:0] F, output cout, output reg isEqual);
  
    //Implementation overview - 
    //Create two 4 bit registers x and y to store the intermediate results depedning on the value of Mode
    //The final 4 bit register F contains the sum of x and y (calculated using carry look ahead adder defined above)

    reg [3:0] x, y;
    wire ret; 
    
  always@(A , B, Select, Mode) begin
      if(Mode)     
          //LOGICAL operations
            begin                  
              case (Select)
                    0: begin
                        x = ~A;  
                        y = 4'b0000;
                       end
                
                    1: begin
                        x = (~A) | (~B);
                        y = 4'b0000;
                       end
                
                    2: begin
                        x = (~A)&(B);
                        y = 4'b0000;
                       end
                
                    3: begin
                        x = 4'b0000;
                        y = 4'b0000;
                       end     
                
                    4: begin
                        x = ~(A&B);
                        y = 4'b0000;
                       end
                
                    5: begin
                        x = ~B;
                        y = 4'b0000;
                       end
                
                    6: begin
                        x = A^B;
                        y = 4'b0000;
                       end
                
                    7: begin
                        x = A&(~B);
                        y = 4'b0000;
                       end
                
                    8: begin
                      x = (~A)|(B);
                        y = 4'b0000;
                       end
                
                    9: begin
                        x = (~A)^(~B);
                        y = 4'b0000;
                       end
                
                    10: begin
                        x = B;
                        y = 4'b0000;
                      end
                
                    11: begin
                        x = A&B;
                        y = 4'b0000;
                        end
                
                    12: begin
                        x = 4'b0001;
                        y = 4'b0000;
                        end
                
                    13: begin
                        x = A|(~B);
                        y = 4'b0000;
                        end
                
                    14: begin
                        x = A|B;
                        y = 4'b0000;
                        end
                
                    15: begin
                        x = A;
                        y = 4'b0000;
                        end                      
                endcase              
            end
        else      
          //ARITHMETIC operations
            begin
              case (Select)
                    0: begin
                        x = A;
                        y = 4'b0000;                        
                       end
                  
                    1: begin
                        x = A | B;
                        y = 4'b0000;
                       end
                  
                    2: begin
                        x = A | ~B;
                        y = 4'b0000;
                       end
                  
                    3: begin
                        x = 4'b1111; //2's complement of zero
                        y = 4'b0000;
                       end  
                  
                    4: begin
                        x = A;
                        y = A&(~B);
                       end
                  
                    5: begin
                        x = A | B;
                        y = A&(~B);
                       end
                  
                    6: begin
                        x = A;
                        y = ~B;
                       end
                  
                    7: begin
                        x = A&B;
                        y = 4'b1111;
                       end
                  
                    8: begin
                        x = A;
                        y = A&B; 
                       end
                  
                    9: begin
                        x = A;
                        y = B;
                       end
                  
                    10: begin
                        x = A | (~B);
                        y = A&B;
                        end
                  
                    11: begin
                        x = A&B;
                        y = 4'b1111;
                        end
                  
                    12: begin
                        x = A;
                        y = A; 
                        end
                  
                    13: begin
                        x = A|B;
                        y = A;
                      end
                  
                    14: begin
                        x = A | (~B);
                        y = A;
                        end
                  
                    15: begin
                        x = A;
                        y = 4'b1111;
                        end                      
                endcase                   
            end
    
      if(A == B) begin
        isEqual = 4'b0001;
      end
      else begin
        isEqual = 4'b0000;
      end      
    end 
    
    
    //Add x and y and store result int output F 
    CarryLookAhead4bit here(
        .x(x),
        .y(y),
        .cin(!cin),
        .sum(F),
        .cout(ret)
    );
  
    not finalInvert(cout,ret);
    
endmodule

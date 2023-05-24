`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 08:22:59 PM
// Design Name: 
// Module Name: full_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module full_adder(input         A_I                                                 ,
                  input         B_I                                                 ,
                  input         CARRY_I                                             ,
                  output        SUM_O                                               ,
                  output        CARRY_OUT_O                                        );

assign  SUM_O                   = A_I ^ B_I ^ CARRY_I                               ;
assign  CARRY_OUT_O             = (A_I & B_I) + (B_I & CARRY_I) + (A_I & CARRY_I)   ; 
endmodule

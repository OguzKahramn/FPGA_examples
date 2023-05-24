`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 08:11:44 PM
// Design Name: 
// Module Name: ripple_adder
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


module ripple_adder
  #(parameter N=4)
  (input [N-1:0]                  A_I                                               ,
   input [N-1:0]                  B_I                                               ,
   input                          CARRY_I                                           ,
   output[N-1:0]                  SUM_O                                             ,
   output                         CARRY_OUT_O                                      );

  wire [N:0] carry;

  genvar i;
  generate
    for(i=0; i<N; i=i+1) begin
      full_adder fa_inst
      (
        .A_I(A_I[i]),
        .B_I(B_I[i]),
        .CARRY_I(carry[i]),
        .SUM_O(SUM_O[i]),
        .CARRY_OUT_O(carry[i+1])
      );
    end
  endgenerate

  assign carry[0] = CARRY_I;
  assign CARRY_OUT_O = carry[N];
endmodule

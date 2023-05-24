`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2023 08:47:41 PM
// Design Name: 
// Module Name: ripple_adder_tb
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


module ripple_adder_tb();

reg [3:0] a_r;
reg [3:0] b_r;
reg carry_r;

wire [3:0] sum_w ;
wire carry_out_w ;

ripple_adder r0(
       .A_I             (a_r)                                  ,
       .B_I             (b_r)                                  ,
       .CARRY_I         (carry_r)                              ,
       .SUM_O           (sum_w)                                ,
       .CARRY_OUT_O     (carry_out_w)                         );

initial begin
  a_r  <= 4'd0;
  b_r  <= 4'd0;
  carry_r<= 0 ;
  #10
  a_r <= 4'd8;
  b_r <= 4'd9;
  #10
  a_r <= 4'd4;
  b_r <= 4'd5;
  #10
  a_r <= 4'd2;
  b_r <= 4'd10;
  #10
  a_r <= 4'd12;
  b_r <= 4'd3;
  #10
  a_r <= 4'd8;
  b_r <= 4'd8;
  #10
  a_r <= 4'd13;
  b_r <= 4'd15;
  #10
  a_r <= 4'd3;
  b_r <= 4'd8;
end
endmodule

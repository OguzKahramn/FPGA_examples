`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2023 07:14:11 PM
// Design Name: 
// Module Name: digital_thermometer_tb
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


module digital_thermometer_tb();

reg                          clk_tb_r                                               ;
reg                          rst_n_tb_r                                             ;
reg [9:0]                    analog_in_tb_r                                         ;
reg                          en_tb_r                                                ;

wire [6:0]                   degree_cel_w                                           ;
wire                         valid_w                                                ;

localparam                   T                        = 10                          ;

always #(T/2)                clk_tb_r                 = ! clk_tb_r                  ;

digital_thermometer t0(      .CLK_I        ( clk_tb_r         )                     ,                    
                             .RST_N_I      ( rst_n_tb_r       )                     ,
                             .EN_I         ( en_tb_r          )                     ,
                             .ANALOG_IN_I  ( analog_in_tb_r   )                     ,
                             .DEGREE_O     ( degree_cel_w     )                     ,
                             .VALID_O      ( valid_w          ))                    ;

initial begin
  clk_tb_r                                            <= 1                          ;
  rst_n_tb_r                                          <= 0                          ;
  analog_in_tb_r                                      <= 0                          ;
  en_tb_r                                             <= 0                          ;
  #(T*5)                                                                            ;
  rst_n_tb_r                                          <= 1                          ;
  #(T*5)                                                                            ; 
  analog_in_tb_r                                      <= 9'd1023                     ;
  en_tb_r                                             <= 1                          ;
  #(T *2)                                                                           ;
  en_tb_r                                             <= 0                          ;
end
endmodule

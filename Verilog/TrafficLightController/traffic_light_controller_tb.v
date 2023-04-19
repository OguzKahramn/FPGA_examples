`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2023 07:17:33 PM
// Design Name: 
// Module Name: traffic_light_controller_tb
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


module traffic_light_controller_tb();

reg                               clk_tb_r                                          ;
reg                               rst_n_tb_r                                        ;
reg                               en_tb_r                                           ;

wire                              red_w                                             ;
wire                              yellow_w                                          ;
wire                              green_w                                           ;

localparam                        T                   = 10                          ; // 10 ns 
traffic_light_controller t0 (     .CLK_I              (  clk_tb_r    )              ,
                                  .RST_N_I            (  rst_n_tb_r  )              ,
                                  .EN_I               (  en_tb_r     )              ,
                                  .RED_O              (  red_w       )              ,
                                  .YELLOW_O           (  yellow_w    )              ,
                                  .GREEN_O            (  green_w     )             );

always #(T/2)                     clk_tb_r            = !clk_tb_r                   ;

initial begin
  clk_tb_r                                            <= 1                          ;
  rst_n_tb_r                                          <= 0                          ;
  en_tb_r                                             <= 0                          ;
  #(T*5)                                                                            ;
  rst_n_tb_r                                          <= 1                          ;
  #(3000000)                                                                        ;
  en_tb_r                                             <= 1                          ;
end

endmodule

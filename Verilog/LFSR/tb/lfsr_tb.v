`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2023 12:53:45 PM
// Design Name: 
// Module Name: lfsr_tb
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


module lfsr_tb();

reg                               clk_tb_r                                          ;
reg                               rst_n_tb_r                                        ;
reg                               en_tb_r                                           ;
wire [7:0]                        q_tb_w                                            ;

localparam                        T                   = 10                          ;

lfsr      l0                    (   .CLK_I            ( clk_tb_r   )                ,
                                    .RESET_I          ( rst_n_tb_r )                ,
                                    .EN_I             ( en_tb_r    )                ,
                                    .Q_O              ( q_tb_w     )               );

always #(T/2)                      clk_tb_r           = ! clk_tb_r                  ;

initial 
begin
  clk_tb_r                                            <= 0                          ;
  rst_n_tb_r                                          <= 0                          ;
  en_tb_r                                             <= 0                          ;
  # (T*10)                                                                          ;
  rst_n_tb_r                                          <= 1                          ;
  en_tb_r                                             <= 1                          ;   
end

endmodule

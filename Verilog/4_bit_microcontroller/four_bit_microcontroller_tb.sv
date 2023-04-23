`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2023 04:03:49 PM
// Design Name: 
// Module Name: four_bit_microcontroller_tb
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


module four_bit_microcontroller_tb();

reg                                    clk_tb_r                                     ;
reg                                    rst_n_tb_r                                   ;
reg [3:0]                              data_in_tb_r                                 ;
reg [3:0]                              instruction_tb_r                             ;

wire [3:0]                             data_out_w                                   ;

four_bit_microcontroller uut (         .CLK_I          (clk_tb_r           )        , 
                                       .RST_N_I        (rst_n_tb_r         )        , 
                                       .DATA_IN_I      (data_in_tb_r       )        , 
                                       .INSTRUCTION_I  (instruction_tb_r   )        , 
                                       .DATA_OUT_O     (data_out_w         )      ) ;

localparam                             T              = 10                          ;

always #(T/2)                          clk_tb_r       = !clk_tb_r                   ;
initial begin
  clk_tb_r                                            <= 1                          ;
  rst_n_tb_r                                          <= 0                          ;
  data_in_tb_r                                        <= 0                          ;
  instruction_tb_r                                    <= 0                          ;
  #(T*5)                                                                            ;
  rst_n_tb_r                                          <= 1                          ;
  instruction_tb_r                                    <= 4'd1                       ;
  data_in_tb_r                                        <= 4'd5                       ;
  #(T)                                                                              ;
  instruction_tb_r                                    <= 4'd2                       ;
  #(T)                                                                              ;
  instruction_tb_r                                    <= 4'd1                       ;
  data_in_tb_r                                        <= 4'd7                       ;
  #(T)                                                                              ;
  instruction_tb_r                                    <= 4'd2                       ;
  #(T)                                                                              ;
  instruction_tb_r                                    <= 4'd7                       ;
  #(T)                                                                              ;
  instruction_tb_r                                    <= 4'd0                       ;
end

endmodule

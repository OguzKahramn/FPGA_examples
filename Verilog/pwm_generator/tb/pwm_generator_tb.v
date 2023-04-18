`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2023 07:02:41 PM
// Design Name: 
// Module Name: pwm_generator_tb
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


module pwm_generator_tb();

reg                               clk_tb_r                                          ;
reg                               rst_n_tb_r                                        ;
reg                               en_tb_r                                           ;
reg [7:0]                         duty_cyc_tb_r                                     ;

wire                              busy_tb_w                                         ;
wire                              pwm_tb_w                                          ;

localparam                        T                   = 10                          ; 

pwm_generator                 p0( .CLK_I              (  clk_tb_r       )           ,        
                                  .RST_N_I            (  rst_n_tb_r     )           ,      
                                  .EN_I               (  en_tb_r        )           ,      
                                  .DUTY_CYCLE_I       (  duty_cyc_tb_r  )           ,      
                                  .BUSY_O             (  busy_tb_w      )           ,      
                                  .PWM_OUT_O          (  pwm_tb_w       ))          ;      

always #(T/2) clk_tb_r                                = ! clk_tb_r                  ;

initial begin
  clk_tb_r                                            <= 1                          ;
  en_tb_r                                             <= 0                          ;
  rst_n_tb_r                                          <= 0                          ;
  duty_cyc_tb_r                                       <= 0                          ;
  #(T*5)                                                                            ;
  rst_n_tb_r                                          <= 1                          ;
  #(T*2)                                                                            ;
  en_tb_r                                             <= 1                          ;
  duty_cyc_tb_r                                       <= 8'd100                     ;
end

endmodule

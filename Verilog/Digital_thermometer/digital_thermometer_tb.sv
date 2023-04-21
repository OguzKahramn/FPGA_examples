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
reg [1:0]                    tb_state_machine                                       ;
reg [2:0]                    counter_tb_r                                           ;

wire [6:0]                   degree_cel_w                                           ;
wire                         valid_w                                                ;
wire                         busy_w                                                 ;

localparam                   T                        = 10                          ;

localparam                   COUNT_S                  = 2'b00                       ,
                             TEST_S                   = 2'b01                       ,
                             WAIT_DONE_S              = 2'b10                       ;

always #(T/2)                clk_tb_r                 = ! clk_tb_r                  ;

digital_thermometer t0(      .CLK_I        ( clk_tb_r         )                     ,                    
                             .RST_N_I      ( rst_n_tb_r       )                     ,
                             .EN_I         ( en_tb_r          )                     ,
                             .ANALOG_IN_I  ( analog_in_tb_r   )                     ,
                             .DEGREE_O     ( degree_cel_w     )                     ,
                             .BUSY_O       ( busy_w           )                     ,
                             .VALID_O      ( valid_w          ))                    ;

initial begin
  clk_tb_r                                            <= 1                          ;
  rst_n_tb_r                                          <= 0                          ;
  analog_in_tb_r                                      <= 0                          ;
  en_tb_r                                             <= 0                          ;
  #(T*5)                                                                            ;
  rst_n_tb_r                                          <= 1                          ;
end

always @(posedge clk_tb_r) begin
  if(!rst_n_tb_r) begin
    analog_in_tb_r                                    <= 0                          ;
    en_tb_r                                           <= 0                          ;
    counter_tb_r                                      <= 0                          ;
    tb_state_machine                                  <= COUNT_S                    ;
  end
  else begin
    case(tb_state_machine)

    COUNT_S : begin
      if(counter_tb_r != 3'b111) begin
        counter_tb_r                                  <= counter_tb_r + 1           ;
        tb_state_machine                              <= COUNT_S                    ;
      end
      else begin
        counter_tb_r                                  <= 0                          ;
        tb_state_machine                              <= TEST_S                     ;
      end
    end

    TEST_S : begin
      en_tb_r                                         <= 1                          ;
      analog_in_tb_r                                  <= $random                    ;
      tb_state_machine                                <= WAIT_DONE_S                ;
    end

    WAIT_DONE_S : begin
      en_tb_r                                         <= 0                          ;
      if(!busy_w) begin
        tb_state_machine                              <= COUNT_S                    ;
      end
      else begin
        tb_state_machine                              <= WAIT_DONE_S                ;
      end
    end 
    default: tb_state_machine                         <= COUNT_S                    ;
    endcase
  end

end
endmodule

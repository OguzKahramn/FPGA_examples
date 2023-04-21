`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2023 06:56:32 PM
// Design Name: 
// Module Name: binary2gray_coder_tb
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


module binary2gray_coder_tb();

reg                          clk_tb_r                                               ;
reg                          rst_n_tb_r                                             ;
reg                          en_tb_r                                                ;
reg  [7:0]                   data_in_tb_r                                           ;
reg  [1:0]                   tb_state_machine                                       ;
reg  [2:0]                   counter_r                                              ;

wire [7:0]                   data_out_w                                             ;
wire                         done_w                                                 ;
wire                         busy_w                                                 ;

binary2gray_coder c0 (       .CLK_I              ( clk_tb_r     )                   , 
                             .RST_N_I            ( rst_n_tb_r   )                   ,
                             .EN_I               ( en_tb_r      )                   ,
                             .DATA_IN_I          ( data_in_tb_r )                   ,
                             .DATA_OUT_O         ( data_out_w   )                   ,
                             .DONE_O             ( done_w       )                   ,
                             .BUSY_O             ( busy_w       )                  );

localparam                   T                        = 10                          ;

localparam                   COUNT_S                  = 2'b00                       ,
                             TEST_S                   = 2'b01                       ,
                             WAIT_DONE_S              = 2'b10                       ;

always #(T/2)                clk_tb_r                 = ! clk_tb_r                  ;

initial begin
  clk_tb_r                                            <= 1                          ;
  data_in_tb_r                                        <= 0                          ;
  en_tb_r                                             <= 0                          ;
  rst_n_tb_r                                          <= 0                          ;
  #(T*5)                                                                            ;
  rst_n_tb_r                                          <= 1                          ;
  // #(T*2)                                                                            ;
  // data_in_tb_r                                        <= 8'b0101_0101               ;
  // en_tb_r                                             <= 1                          ;
  // #(T);
  // en_tb_r                                             <= 0                          ;
end

always @(posedge clk_tb_r) begin
  if(!rst_n_tb_r) begin
    en_tb_r                                           <= 0                          ;
    data_in_tb_r                                      <= 0                          ;
    counter_r                                         <= 0                          ;
    tb_state_machine                                  <= COUNT_S                    ;
  end
  else begin
    case(tb_state_machine) 

    COUNT_S : begin
      if(counter_r != 3'b111) begin
        counter_r                                     <= counter_r + 1              ;
        tb_state_machine                              <= COUNT_S                    ;
      end
      else begin
        counter_r                                     <= 0                          ;
        tb_state_machine                              <= TEST_S                     ;
      end
    end
    TEST_S : begin
      data_in_tb_r                                    <= $random                    ;
      en_tb_r                                         <= 1                          ;
      tb_state_machine                                <= WAIT_DONE_S                ;
    end

    WAIT_DONE_S : begin
      en_tb_r                                         <= 0                          ;
      if(done_w) begin
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

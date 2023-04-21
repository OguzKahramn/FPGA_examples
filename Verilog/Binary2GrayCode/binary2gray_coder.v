`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2023 06:23:35 PM
// Design Name: 
// Module Name: binary2gray_coder
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


module binary2gray_coder(    input          CLK_I                                   ,
                             input          RST_N_I                                 ,
                             input          EN_I                                    ,
                             input [7:0]    DATA_IN_I                               ,
                             output [7:0]   DATA_OUT_O                              ,
                             output         DONE_O                                  ,
                             output         BUSY_O                                 );

//________________________________________ REGISTER DECLARATION _____________________________________//

reg      [1:0]               coder_state_machine                                    ;
reg      [7:0]               data_in_r                                              ;
reg      [7:0]               data_out_r                                             ;
reg                          busy_r                                                 ;
reg                          done_r                                                 ;
reg                          en_pre_r                                               ;    

//________________________________________ CONSTANT DECLARATION ____________________________________//

localparam                   IDLE_S                   = 2'b00                       ,
                             CONVERT_S                = 2'b01                       ;
//________________________________________ WIRE DECLARATION _________________________________________//

wire                         en_w                                                   ;

//________________________________________ ASYNC ASSIGNMENTS ________________________________________//

assign                       en_w                     = EN_I                        ;
assign                       DATA_OUT_O               = data_out_r                  ;
assign                       BUSY_O                   = busy_r                      ;
assign                       DONE_O                   = done_r                      ;

//________________________________________ MAIN LOGIC _______________________________________________//

always @(posedge CLK_I) begin
  if(!RST_N_I) begin
    data_in_r                                         <= 0                          ;
    data_out_r                                        <= 0                          ;
    busy_r                                            <= 0                          ;
    done_r                                            <= 0                          ;
    en_pre_r                                          <= 0                          ;
    coder_state_machine                               <= IDLE_S                     ;
  end
  else begin
    en_pre_r                                          <= EN_I                       ;
    case(coder_state_machine)

    IDLE_S : begin
      if(!en_pre_r & en_w) begin
        data_in_r                                     <= DATA_IN_I                  ;
        done_r                                        <= 0                          ;
        busy_r                                        <= 1                          ;
        coder_state_machine                           <= CONVERT_S                  ;
      end
      else begin
        busy_r                                        <= 0                          ;
        done_r                                        <= 0                          ;
        coder_state_machine                           <= IDLE_S                     ;
      end
    end

    CONVERT_S : begin
      data_out_r[0]                                   <= data_in_r[1] ^ data_in_r[0];
      data_out_r[1]                                   <= data_in_r[2] ^ data_in_r[1];
      data_out_r[2]                                   <= data_in_r[3] ^ data_in_r[2];
      data_out_r[3]                                   <= data_in_r[4] ^ data_in_r[3];
      data_out_r[4]                                   <= data_in_r[5] ^ data_in_r[4];
      data_out_r[5]                                   <= data_in_r[6] ^ data_in_r[5];
      data_out_r[6]                                   <= data_in_r[7] ^ data_in_r[6];
      data_out_r[7]                                   <= data_in_r[7]               ;
      busy_r                                          <= 0                          ;
      done_r                                          <= 1                          ;
      coder_state_machine                             <= IDLE_S                     ;
    end

    default : coder_state_machine                     <= IDLE_S                     ;
    endcase  
  end
end

endmodule

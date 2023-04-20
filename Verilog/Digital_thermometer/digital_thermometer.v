`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2023 06:49:21 PM
// Design Name: 
// Module Name: digital_thermometer
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


module digital_thermometer(  input          CLK_I                                   ,
                             input          RST_N_I                                 ,
                             input          EN_I                                    ,
                             input  [9:0]   ANALOG_IN_I                             ,
                             output [6:0]   DEGREE_O                                ,
                             output         VALID_O                                );

// ______________________________ REGISTER DECLARATION _________________________________________//
reg                          thermo_state_machine                                   ;
reg  [9:0]                   analog_in_r                                            ;
reg  [6:0]                   degree_celc_r                                          ;
reg                          pre_en_r                                               ;
reg                          valid_r                                                ;
reg  [6:0]                   max_temp_r                                             ;
reg  [9:0]                   convert_val_r                                          ;
reg  [2:0]                   level_range_r                                          ;
reg  [2:0]                   counter_r                                              ;
//_______________________________ CONSTANT DECLARATION _________________________________________//
localparam                   IDLE_S                   = 1'b0                        ,
                             SHOW_TEMP_S              = 1'b1                        ;

localparam                   MAX_TEMP_CELC_C          = 7'd100                      ,
                             MIN_TEMP_CELC_C          = 7'd0                        ,
                             CONVERT_VAL_C            = 10'd1023                    ,
                             LEVEL_RANGE_C            = 3'd7                        ;
//_______________________________ WIRE DECLARATION _____________________________________________//

wire                         en_w                                                   ;

//_______________________________ ASYNC ASSIGNMENTS ____________________________________________//

assign                       DEGREE_O                 = degree_celc_r               ;
assign                       en_w                     = EN_I                        ;
assign                       VALID_O                  = valid_r                     ;
//_______________________________ MAIN LOGIC ___________________________________________________//

always @(posedge CLK_I) begin
  if(!RST_N_I) begin
    analog_in_r                                       <= 0                          ;
    max_temp_r                                        <= 7'd100                     ;
    convert_val_r                                     <= 10'd1023                   ;
    level_range_r                                     <= 3'd7                       ;
    degree_celc_r                                     <= 0                          ;
    pre_en_r                                          <= 0                          ;
    valid_r                                           <= 0                          ;
    counter_r                                         <= 0                          ;
    thermo_state_machine                              <= 0                          ;
  end
  else begin
    pre_en_r                                          <= EN_I                       ;
    case(thermo_state_machine)

    IDLE_S : begin
      if(!pre_en_r & en_w) begin // posedge of EN_I
        analog_in_r                                   <= ANALOG_IN_I                ;
        thermo_state_machine                          <= SHOW_TEMP_S                ;
      end
      else begin
        analog_in_r                                   <= 0                          ;
        degree_celc_r                                 <= 0                          ;
        thermo_state_machine                          <= IDLE_S                     ;
      end
      valid_r                                         <= 0                          ;
    end

    SHOW_TEMP_S : begin
      if(counter_r != 3'b111) begin
        counter_r                                     <= counter_r + 1              ;
        degree_celc_r                                 <= (analog_in_r /600  )       ;
        valid_r                                       <= 1                          ;
        thermo_state_machine                          <= SHOW_TEMP_S                ;
      end
      else begin
        counter_r                                     <= 0                          ;
        thermo_state_machine                          <= IDLE_S                     ;
      end
    end
    default: thermo_state_machine                     <= IDLE_S                     ;
    endcase
  end
end
endmodule

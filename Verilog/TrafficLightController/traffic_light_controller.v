`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2023 07:17:33 PM
// Design Name: 
// Module Name: traffic_light_controller
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


module traffic_light_controller(  input               CLK_I                         ,
                                  input               RST_N_I                       ,
                                  input               EN_I                          ,
                                  output              RED_O                         ,
                                  output              YELLOW_O                      ,
                                  output              GREEN_O                      );

//_________________________________________ REGISTER DECLARATION ____________________________________//
reg   [1:0]                       traf_light_state_mch                              ;
reg   [1:0]                       direction_r                                       ;
reg   [35:0]                      counter_r                                         ;
reg                               red_r                                             ;
reg                               yellow_r                                          ;
reg                               green_r                                           ;
//_________________________________________ CONSTANT DECLARATION ____________________________________//
localparam                        IDLE_S              = 2'b00                       ,
                                  RED_S               = 2'b01                       ,
                                  YELLOW_S            = 2'b10                       ,
                                  GREEN_S             = 2'b11                       ;

localparam                        RED_DURATION_C      = 36'd60000000000             , // 60 seconds
                                  YELLOW_DURATION_C   = 36'd3000000000              , //  3 seconds
                                  GREEN_DURATION_C    = 36'd30000000000             ; // 30 seconds                     
//_________________________________________ WIRE DECLARATION ________________________________________//


//_________________________________________ ASYNC ASSIGNMENTS ________________________________________//

assign                            RED_O               = red_r                       ;
assign                            YELLOW_O            = yellow_r                    ;
assign                            GREEN_O             = green_r                     ;

//_________________________________________ MAIN LOGIC _______________________________________________//

always @(posedge CLK_I) begin
  if(!RST_N_I) begin
    direction_r                                       <= 0                          ;
    red_r                                             <= 0                          ;
    yellow_r                                          <= 0                          ;
    green_r                                           <= 0                          ;
    counter_r                                         <= 36'd0                      ;
    traf_light_state_mch                              <= IDLE_S                     ;
  end
  else begin
    case(traf_light_state_mch)

    IDLE_S : begin
      if(EN_I) begin
        counter_r                                     <= 0                          ;
        red_r                                         <= 1                          ;
        yellow_r                                      <= 0                          ;
        green_r                                       <= 0                          ;
        traf_light_state_mch                          <= RED_S                      ;
      end
      else begin
        if(counter_r != YELLOW_DURATION_C) begin
          counter_r                                   <= counter_r + 1              ;
          red_r                                       <= 0                          ;
          yellow_r                                    <= 0                          ;
          green_r                                     <= 0                          ;
          traf_light_state_mch                        <= IDLE_S                     ;
        end
        else begin
          red_r                                       <= 0                          ;
          yellow_r                                    <= 1                          ;
          green_r                                     <= 0                          ;
          counter_r                                   <= 0                          ;
          direction_r                                 <= 0                          ;
          traf_light_state_mch                        <= YELLOW_S                   ;
        end
      end
    end

    RED_S : begin
      if(counter_r != RED_DURATION_C) begin
        counter_r                                     <= counter_r + 1              ;
        traf_light_state_mch                          <= RED_S                      ;
      end
      else begin
        counter_r                                     <= 0                          ;
        red_r                                         <= 0                          ;
        yellow_r                                      <= 1                          ;
        direction_r                                   <= 1                          ;
        traf_light_state_mch                          <= YELLOW_S                   ;
      end
    end

    YELLOW_S : begin
      if(counter_r != YELLOW_DURATION_C) begin
        counter_r                                     <= counter_r + 1              ;
        traf_light_state_mch                          <= YELLOW_S                   ;
      end
      else begin
        counter_r                                     <= 0                          ;
        yellow_r                                      <= 0                          ;
        case(direction_r)

        0 : begin
          traf_light_state_mch                        <= IDLE_S                     ;
        end

        1 : begin
          green_r                                     <= 1                          ;
          traf_light_state_mch                        <= GREEN_S                    ;
        end

        2 : begin
          red_r                                       <= 1                          ;
          traf_light_state_mch                        <= RED_S                      ;
        end

        default : traf_light_state_mch                <= IDLE_S                     ;
        endcase
      end
    end

    GREEN_S : begin
      if(counter_r != GREEN_DURATION_C) begin
        counter_r                                     <= counter_r + 1              ;
        traf_light_state_mch                          <= GREEN_S                    ;
      end
      else begin
        counter_r                                     <= 0                          ;
        green_r                                       <= 0                          ;
        direction_r                                   <= 2                          ;
        yellow_r                                      <= 1                          ;
        traf_light_state_mch                          <= YELLOW_S                   ;
      end
    end

    default : traf_light_state_mch                    <= IDLE_S                     ;
    endcase
  end  
end

endmodule

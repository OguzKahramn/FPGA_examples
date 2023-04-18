`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2023 06:47:34 PM
// Design Name: 
// Module Name: pwm_generator
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


module pwm_generator(input        CLK_I                                             ,
                     input        RST_N_I                                           ,
                     input        EN_I                                              ,
                     input [7:0]  DUTY_CYCLE_I                                      ,
                     output       BUSY_O                                            ,
                     output       PWM_OUT_O                                        );

reg [7:0]                         counter_r                                         ;
reg [7:0]                         duty_cyc_r                                        ;
reg [1:0]                         state_machine_r                                   ;
reg                               busy_r                                            ;
reg                               pwm_out_r                                         ;


localparam                        IDLE_S              = 2'b00                       ,
                                  GENERATE_S          = 2'b01                       ;

assign  BUSY_O                                        = busy_r                      ;
assign  PWM_OUT_O                                     = pwm_out_r                   ;

always @(posedge CLK_I) begin
  if(!RST_N_I)begin
    counter_r                                         <= 0                          ;
    busy_r                                            <= 0                          ;
    duty_cyc_r                                        <= 0                          ;
    pwm_out_r                                         <= 0                          ;
    state_machine_r                                   <= 0                          ;
  end
  else begin
    case(state_machine_r)

    IDLE_S : begin
      if(EN_I) begin
        busy_r                                        <= 1'b1                       ;
        counter_r                                     <= 8'd0                       ;
        duty_cyc_r                                    <= DUTY_CYCLE_I               ;
        state_machine_r                               <= GENERATE_S                 ;
      end
      else begin
        busy_r                                        <= 1'b0                       ;
        counter_r                                     <= 8'd0                       ;
        state_machine_r                               <= IDLE_S                     ;
      end
    end

    GENERATE_S : begin
      if(counter_r < duty_cyc_r) begin
        pwm_out_r                                     <= 1                          ;
      end
      else begin
        pwm_out_r                                     <= 0                          ;
      end 
      counter_r                                       <= counter_r + 1              ;                            
    end
    default : state_machine_r                         <= IDLE_S                     ;
    endcase
  end  
end
endmodule

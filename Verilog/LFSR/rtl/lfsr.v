`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2023 12:36:48 PM
// Design Name: 
// Module Name: lfsr
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


module lfsr(                      input               CLK_I                         ,
                                  input               RESET_I                       ,
                                  input               EN_I                          ,
                                  output [7:0]        Q_O                          );

// _________________________________________ REGISTER DECLARATION ______________________________________________//
reg [7:0]                         q_r                                               ;
reg [15:0]                        counter_r                                         ;
reg [1:0]                         lfsr_state_mach                                   ;

//__________________________________________ ASYNC ASSIGNMENTS _________________________________________________//
assign                            Q_O                 = q_r                         ;
assign                            taps_w              = q_r[7]^q_r[5]^q_r[4]^q_r[3] ;

// _________________________________________ CONSTANT DECLARATION_______________________________________________//
localparam                        IDLE_S              = 2'b00                       ,
                                  SHIFT_S             = 2'b01                       ;

// __________________________________________ WIRE DECLARATION _________________________________________________//
wire                              taps_w                                            ;

//__________________________________________ MAIN LOGIC_________________________________________________________//

always @(posedge CLK_I) 
begin
  if(!RESET_I)
  begin
    q_r                                               <= 8'b1111_1111               ;
    counter_r                                         <= 16'd0                      ;
    lfsr_state_mach                                   <= IDLE_S                     ;
  end
  else
  begin
    case(lfsr_state_mach)
    IDLE_S :
    begin
    if(EN_I)
      begin
        lfsr_state_mach                               <= SHIFT_S                    ;
      end
      else
      begin
        lfsr_state_mach                               <= IDLE_S                     ;
      end
    end
    SHIFT_S :
    begin
      q_r                                             <= {q_r[6:0],taps_w}          ; 
      counter_r                                       <= counter_r + 1              ;
      lfsr_state_mach                                 <= IDLE_S                     ;
    end
    default : lfsr_state_mach                         <= IDLE_S                     ;
    endcase
  end	
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2023 02:54:59 PM
// Design Name: 
// Module Name: four_bit_microcontroller
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


module four_bit_microcontroller(  input               CLK_I                         ,
                                  input               RST_N_I                       ,
                                  input  [3:0]        DATA_IN_I                     ,
                                  input  [3:0]        INSTRUCTION_I                 ,
                                  output [3:0]        DATA_OUT_O                   );

//_____________________________________ REGISTER DECLARATION ________________________________________//
reg      [3:0]                    reg_a_r                                           ;
reg      [3:0]                    program_counter_r                                 ;
reg      [3:0]                    acc_reg_r                                         ;
reg      [3:0]                    data_out_r                                        ;
// ____________________________________ CONSTANT_DECLARATION ________________________________________//
localparam                        IDLE_S              = 4'b0000                     ,
                                  MOV_S               = 4'b0001                     ,
                                  ADD_S               = 4'b0010                     ,
                                  SUB_S               = 4'b0011                     ,
                                  JMP_S               = 4'b0100                     ,
                                  JZ_S                = 4'b0101                     ,
                                  JNZ_S               = 4'b0110                     ,
                                  OUT_S               = 4'b0111                     ;

// ____________________________________ WIRE_DECLARATION _____________________________________________//

//_____________________________________ ASYNC ASSIGNMENTS ____________________________________________//
assign                            DATA_OUT_O          = data_out_r                  ;
//_____________________________________ MAIN LOGIC ___________________________________________________//

always @(posedge CLK_I) begin
  if(!RST_N_I) begin
    reg_a_r                                           <= 0                          ;
    program_counter_r                                 <= 0                          ;
    data_out_r                                        <= 0                          ;
    acc_reg_r                                         <= 0                          ;
  end
  else begin
    case(INSTRUCTION_I)
      IDLE_S:                                                                       ;

      MOV_S : begin
        reg_a_r                                       <= DATA_IN_I                  ;
      end

      ADD_S : begin
        acc_reg_r                                     <= acc_reg_r + reg_a_r        ;
      end

      SUB_S : begin
        acc_reg_r                                     <= acc_reg_r - reg_a_r        ;
      end

      JMP_S : begin 
        program_counter_r                             <= reg_a_r                    ;
      end

      JZ_S : begin
        if(acc_reg_r == 0) begin
          program_counter_r                           <= reg_a_r                    ;
        end
        else begin
          program_counter_r                           <= program_counter_r          ;
        end
      end

      JNZ_S : begin 
        if(acc_reg_r != 0) begin
          program_counter_r                           <= reg_a_r                    ;
        end
        else begin
          program_counter_r                           <= program_counter_r          ;
        end
      end

      OUT_S : begin
        data_out_r                                    <= acc_reg_r                  ;
      end

    endcase
    program_counter_r                                 <= program_counter_r + 1      ;
  end
end
endmodule

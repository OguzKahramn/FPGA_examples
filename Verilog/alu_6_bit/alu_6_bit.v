`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2023 05:38:46 PM
// Design Name: 
// Module Name: alu_6_bit
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


module alu_6_bit(            input          CLK_I                                   ,
                             input          RST_N_I                                 ,
                             input  [5:0]   DATA_IN_1_I                             ,
                             input  [5:0]   DATA_IN_2_I                             ,
                             input  [5:0]   CONTROL_I                               ,
                             input          EN_I                                    ,
                             output [11:0]  DATA_OUT_O                              ,
                             output         DONE_O                                  ,
                             output         BUSY_O                                 );

// ______________________________________ REGISTER DECLARATION _____________________________________________//

reg   [3:0]                                 alu_state_machine                       ;
reg   [5:0]                                 reg_a_r                                 ;
reg   [5:0]                                 reg_b_r                                 ;
reg   [5:0]                                 control_r                               ;
reg   [11:0]                                data_out_r                              ;
reg                                         busy_r                                  ;
reg                                         done_r                                  ;
reg                                         pre_en_r                                ;
// ______________________________________ CONSTANT DECLARATION _____________________________________________//

localparam                   IDLE_S                   = 6'd0                        ,
                             ADDITION_S               = 6'd1                        ,
                             SUBSTRUCTION_S           = 6'd2                        ,
                             MULTIPLICATION_S         = 6'd3                        ,
                             DIVISION_S               = 6'd4                        ,
                             AND_S                    = 6'd5                        ,
                             OR_S                     = 6'd6                        ,
                             NOT_S                    = 6'd7                        ,
                             XOR_S                    = 6'd8                        ,
                             SHIFT_LEFT_S             = 6'd9                        ,
                             SHIFT_RIGHT_S            = 6'd10                       ,
                             ROTATE_RIGHT_S           = 6'd11                       ,
                             ROTATE_LEFT_S            = 6'd12                       ,
                             SELECT_OPERATION_S       = 6'd13                       ;

// ______________________________________ WIRE DECLARATION _________________________________________________//

wire                                        en_w                                    ;

// ______________________________________ ASYNC ASSIGNMENTS ________________________________________________//

assign   en_w                                         = EN_I                        ;
assign   BUSY_O                                       = busy_r                      ;
assign   DONE_O                                       = done_r                      ;
assign   DATA_OUT_O                                   = data_out_r                  ;
// ______________________________________ MAIN LOGIC _______________________________________________________//

always @(posedge CLK_I) begin
  if(!RST_N_I) begin
    reg_a_r                                           <= 0                          ;
    reg_b_r                                           <= 0                          ;
    control_r                                         <= 0                          ;
    busy_r                                            <= 0                          ;
    done_r                                            <= 0                          ;
    pre_en_r                                          <= 0                          ;
    data_out_r                                        <= 0                          ;
    alu_state_machine                                 <= IDLE_S                     ;
  end
  else begin
    pre_en_r                                          <= EN_I                       ;
    case(alu_state_machine)

    IDLE_S : begin
      if(!pre_en_r && en_w) begin
        reg_a_r                                       <= DATA_IN_1_I                ;
        reg_b_r                                       <= DATA_IN_2_I                ;
        control_r                                     <= CONTROL_I                  ;
        done_r                                        <= 0                          ;
        busy_r                                        <= 1                          ;
        alu_state_machine                             <= SELECT_OPERATION_S         ;
      end
      else begin
        reg_a_r                                       <= 0                          ;
        reg_b_r                                       <= 0                          ;
        control_r                                     <= 0                          ;
        done_r                                        <= 1                          ;
        data_out_r                                    <= 0                          ;
        busy_r                                        <= 0                          ;
        alu_state_machine                             <= IDLE_S                     ;
      end
    end

    SELECT_OPERATION_S : begin
      case(control_r) 
      ADDITION_S             : alu_state_machine      <= ADDITION_S                 ;
      SUBSTRUCTION_S         : alu_state_machine      <= SUBSTRUCTION_S             ;
      MULTIPLICATION_S       : alu_state_machine      <= MULTIPLICATION_S           ;
      DIVISION_S             : alu_state_machine      <= DIVISION_S                 ;
      AND_S                  : alu_state_machine      <= AND_S                      ;
      OR_S                   : alu_state_machine      <= OR_S                       ;
      NOT_S                  : alu_state_machine      <= NOT_S                      ;
      XOR_S                  : alu_state_machine      <= XOR_S                      ;
      SHIFT_LEFT_S           : begin
        reg_a_r                                       <= reg_a_r << reg_b_r         ;
        alu_state_machine                             <= SHIFT_LEFT_S               ;
      end
      SHIFT_RIGHT_S          : begin
        reg_a_r                                       <= reg_a_r >> reg_b_r         ;
        alu_state_machine                             <= SHIFT_RIGHT_S              ;
      end
      ROTATE_RIGHT_S         : begin
        reg_a_r                                       <= {reg_a_r[5-reg_b_r:0],reg_a_r[5:5-reg_b_r+1]};
        alu_state_machine                             <= ROTATE_RIGHT_S             ;
      end
      ROTATE_LEFT_S          : begin
        reg_a_r                                       <= {reg_a_r[reg_b_r-1:0],reg_a_r[5:5-reg_b_r+1]};
        alu_state_machine                             <= ROTATE_LEFT_S              ;
      end
      default                : alu_state_machine      <= IDLE_S                     ;
      endcase
    end

    ADDITION_S : begin
      data_out_r                                      <= reg_a_r + reg_b_r          ;
      done_r                                          <= 1                          ;
      busy_r                                          <= 0                          ;
      alu_state_machine                               <= IDLE_S                     ;
    end

    SUBSTRUCTION_S : begin
      data_out_r                                      <= reg_a_r - reg_b_r          ;
      done_r                                          <= 1                          ;
      busy_r                                          <= 0                          ;
      alu_state_machine                               <= IDLE_S                     ;
    end

    MULTIPLICATION_S : begin
      data_out_r                                      <= reg_a_r * reg_b_r          ;
      done_r                                          <= 1                          ;
      busy_r                                          <= 0                          ;
      alu_state_machine                               <= IDLE_S                     ;
    end

    DIVISION_S : begin
      data_out_r                                      <= reg_a_r / reg_b_r          ;
      done_r                                          <= 1                          ;
      busy_r                                          <= 0                          ;
      alu_state_machine                               <= IDLE_S                     ;
    end

    AND_S : begin
      data_out_r                                      <= reg_a_r && reg_b_r         ;
      done_r                                          <= 1                          ;
      busy_r                                          <= 0                          ;
      alu_state_machine                               <= IDLE_S                     ;
    end

    OR_S : begin
      data_out_r                                      <= reg_a_r || reg_b_r         ;
      done_r                                          <= 1                          ;
      busy_r                                          <= 0                          ;
      alu_state_machine                               <= IDLE_S                     ;
    end

    NOT_S : begin
      data_out_r                                      <= ~ reg_a_r                  ;
      done_r                                          <= 1                          ;
      busy_r                                          <= 0                          ;
      alu_state_machine                               <= IDLE_S                     ;
    end

    XOR_S : begin
      data_out_r                                      <= reg_a_r ^ reg_b_r          ;
      done_r                                          <= 1                          ;
      busy_r                                          <= 0                          ;
      alu_state_machine                               <= IDLE_S                     ;
    end

    SHIFT_LEFT_S : begin
      data_out_r                                      <= reg_a_r                    ;
      done_r                                          <= 1                          ;
      busy_r                                          <= 0                          ;
      alu_state_machine                               <= IDLE_S                     ;
    end

    SHIFT_RIGHT_S : begin
      data_out_r                                      <= reg_a_r                    ;
      done_r                                          <= 1                          ;
      busy_r                                          <= 0                          ;
      alu_state_machine                               <= IDLE_S                     ;
    end

    ROTATE_LEFT_S : begin
      data_out_r                                      <= reg_a_r                    ;
      done_r                                          <= 1                          ;
      busy_r                                          <= 0                          ;
      alu_state_machine                               <= IDLE_S                     ;
    end

    ROTATE_RIGHT_S : begin
      data_out_r                                      <= reg_a_r                    ;
      done_r                                          <= 1                          ;
      busy_r                                          <= 0                          ;
      alu_state_machine                               <= IDLE_S                     ;
    end

    default : alu_state_machine                       <= IDLE_S                     ; 
    endcase
  end
end
endmodule

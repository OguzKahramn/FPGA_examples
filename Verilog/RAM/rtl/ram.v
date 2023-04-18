`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2023 02:47:10 PM
// Design Name: 
// Module Name: ram
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


module ram(                       input               CLK_I                         ,
                                  input               RST_N_I                       ,
                                  input               WR_EN_I                       ,
                                  input  [7:0]        WR_ADDR_I                     ,
                                  input               RD_EN_I                       ,
                                  input  [7:0]        RD_ADDR_I                     ,
                                  input  [7:0]        DATA_IN_I                     ,
                                  output [7:0]        DATA_OUT_O                   );

// ___________________________________ REGISTER DECLARATION ___________________________________//
reg [7:0] mem[255:0]                                                                ;
reg [7:0] data_out_r                                                                ;
reg [1:0] ram_state_machine                                                         ;

//____________________________________ WIRE DECLARATION _______________________________________//

//____________________________________ ASYNC ASSIGNMENTS ______________________________________//
assign DATA_OUT_O                                     = data_out_r                  ;
//____________________________________ CONSTANT DECLARATION ___________________________________//
integer i                                                                           ;
localparam                        IDLE_S              = 2'b00                       ,
                                  READ_S              = 2'b01                       ,
                                  WRITE_S             = 2'b10                       ;
//____________________________________ MAIN LOGIC _____________________________________________//

always @(posedge CLK_I ) 
begin
  if(!RST_N_I)
  begin
    for(i=0;i<256; i= i +1)
    begin
      mem[i]                                          <= 0                          ;
    end
    data_out_r                                        <= 8'b0000_0000               ;
    ram_state_machine                                 <= IDLE_S                     ;
  end
  else
  begin
    case(ram_state_machine)
    IDLE_S :
    begin
      if(WR_EN_I)
      begin
        ram_state_machine                             <= WRITE_S                    ;
      end
      else
      begin
        if(RD_EN_I)
        begin
          ram_state_machine                           <= READ_S                     ;
        end
        else
        begin
          ram_state_machine                           <= IDLE_S                     ;
        end
      end
    end

    WRITE_S :
    begin
      mem[WR_ADDR_I]                                  <= DATA_IN_I                  ;
      ram_state_machine                               <= IDLE_S                     ;
    end

    READ_S :
    begin
      data_out_r                                      <= mem[RD_ADDR_I]             ;
      ram_state_machine                               <= IDLE_S                     ;
    end
    
    default : ram_state_machine                       <= IDLE_S                     ;
    endcase
  end  
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2023 03:09:44 PM
// Design Name: 
// Module Name: ram_tb
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


module ram_tb();

reg                          clk_tb_r                                               ;
reg                          rst_n_tb_r                                             ;
reg                          wr_en_tb_r                                             ;
reg                          rd_en_tb_r                                             ;
reg  [7:0]                   wr_adr_tb_r                                            ;
reg  [7:0]                   rd_adr_tb_r                                            ;
reg  [7:0]                   data_in_tb_r                                           ;
reg  [7:0]                   q_r                                                    ;
reg  [8:0]                   cntr_r                                                 ; 
wire [7:0]                   data_out_tb_w                                          ;
wire                         taps_w                                                 ;
reg  [1:0]                   lfsr_state_machine                                     ;
reg  [1:0]                   tb_state_machine                                       ;

localparam                   T                        = 10                          ;

localparam                   LFSR_IDLE_S              = 2'b00                       ,
                             LFSR_SHIFT_S             = 2'b01                       ;

localparam                   TB_IDLE_S                = 2'b00                       ,
                             TB_WRITE_S               = 2'b01                       ,
                             TB_READ_S                = 2'b10                       ,
                             TB_WAIT_S                = 2'b11                       ;

always #(T/2)                clk_tb_r                 <= ~ clk_tb_r                 ;

assign                       taps_w                   = q_r[7]^q_r[5]^q_r[4]^q_r[3] ;

ram            r0       (    .CLK_I            ( clk_tb_r      )                    , 
                             .RST_N_I          ( rst_n_tb_r    )                    , 
                             .WR_EN_I          ( wr_en_tb_r    )                    , 
                             .WR_ADDR_I        ( wr_adr_tb_r   )                    , 
                             .RD_EN_I          ( rd_en_tb_r    )                    , 
                             .RD_ADDR_I        ( rd_adr_tb_r   )                    , 
                             .DATA_IN_I        ( data_in_tb_r  )                    , 
                             .DATA_OUT_O       ( data_out_tb_w )                   );

initial 
begin
  clk_tb_r                                            <= 0                          ;
  rst_n_tb_r                                          <= 0                          ;
  #(T * 50)                                                                         ;
  rst_n_tb_r                                          <= 1                          ;
end

always @(posedge clk_tb_r)
begin
  if(!rst_n_tb_r)
  begin
    q_r                                               <= 8'b1111_1111               ;
    lfsr_state_machine                                <= LFSR_IDLE_S                ;
  end
  else
  begin
    case(lfsr_state_machine)
    LFSR_IDLE_S:
    begin
      if(wr_en_tb_r)
      begin
        lfsr_state_machine                            <= LFSR_SHIFT_S               ;
      end
      else
      begin
        lfsr_state_machine                            <= LFSR_IDLE_S                ;
      end
    end

    LFSR_SHIFT_S :
    begin
      q_r                                             <= {q_r[6:0],taps_w}          ;
      lfsr_state_machine                              <= LFSR_IDLE_S                ;
    end

    default : lfsr_state_machine                      <= LFSR_IDLE_S                ;
    endcase
  end
end

always@(posedge clk_tb_r)
begin
  if(!rst_n_tb_r)
  begin
    clk_tb_r                                          <= 0                          ;    
    rst_n_tb_r                                        <= 0                          ;
    wr_en_tb_r                                        <= 0                          ;
    rd_en_tb_r                                        <= 0                          ;
    wr_adr_tb_r                                       <= 0                          ;
    rd_adr_tb_r                                       <= 0                          ;
    data_in_tb_r                                      <= 0                          ;
    cntr_r                                            <= 0                          ;
    tb_state_machine                                  <= TB_IDLE_S                  ;
  end
  else
  begin
    case(tb_state_machine)
    TB_IDLE_S:
    begin
      wr_en_tb_r                                      <= 1                          ;
      tb_state_machine                                <= TB_WRITE_S                 ;
    end

    TB_WRITE_S :
    begin
      if(cntr_r != 511)
      begin
        data_in_tb_r                                  <= q_r                        ;
        wr_adr_tb_r                                   <= (cntr_r/2)                 ;
        cntr_r                                        <= cntr_r + 1                 ;
        tb_state_machine                              <= TB_WRITE_S                 ;
      end
      else
      begin
        cntr_r                                        <= 0                          ;
        wr_en_tb_r                                    <= 0                          ;
        rd_en_tb_r                                    <= 1                          ;
        tb_state_machine                              <= TB_READ_S                  ;
      end
    end

    TB_READ_S :
    begin
      if(cntr_r != 511)
      begin
        
        rd_adr_tb_r                                   <= (cntr_r/2)                 ;
        cntr_r                                        <= cntr_r + 1                 ;
        tb_state_machine                              <= TB_READ_S                  ;
      end
      else
      begin
        tb_state_machine                              <= TB_WAIT_S                  ;
      end
    end

    TB_WAIT_S :
    begin
    end
    default : tb_state_machine                        <= TB_IDLE_S                  ;
    endcase
  end
end
endmodule

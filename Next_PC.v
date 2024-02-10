module Next_PC (i_inc_PC, i_imm26, i_reg_addr, i_J, i_Jr, i_Beq, i_Bne, o_PCSrc, o_address, i_zero);

  input signed [29:0]       i_inc_PC;
  input signed [25:0]       i_imm26;
  input [31:0]              i_reg_addr;
  input                     i_J, i_Jr, i_Beq, i_Bne, i_zero;

  output                    o_PCSrc;
  output reg [29:0]         o_address;

  wire signed [29:0]        sign_ext;
  wire [29:0]               addr1, addr2;
  wire                      B;

  assign sign_ext = {{10{i_imm26[15]}},i_imm26[15:0]};
  assign addr1 = i_inc_PC + sign_ext;
  assign addr2 = {i_inc_PC[29:26],i_imm26};
  assign B = i_Beq | i_Bne;
  assign o_PCSrc = i_J | i_Jr | (i_zero&i_Beq) | (~i_zero&i_Bne);

  always @*
  begin
    case(1'b1)
      B: o_address = addr1;
      i_J: o_address = addr2;
      i_Jr: o_address = i_reg_addr[31:2];
    endcase
  end

endmodule

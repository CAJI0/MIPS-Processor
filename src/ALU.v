module ALU (
i_data1, 
i_data2, 
i_shift_op, 
i_arith_op, 
i_logic_op, 
i_select, 
i_sign,
o_zero, 
o_overflow,  
o_less,
o_data
);
  
  parameter WIDTH = 32;
  
  parameter SLL = 0,
            SRL = 1,
            SRA = 2,
            ROR = 3;
  
  parameter ADD = 0,
            SUB = 1;
  
  parameter AND = 0,
            OR = 1,
            NOR = 2,
            XOR = 3;
            
  parameter SHIFT = 0,
            SLT = 1,
            ARITH = 2,
            LOGIC = 3;
  
  input signed [WIDTH - 1:0]        i_data1, i_data2;
  input                             i_arith_op, i_sign;
  input [1:0]                       i_shift_op, i_logic_op, i_select;
  
  output                            o_overflow, o_zero, o_less;
  output reg signed [WIDTH - 1: 0]  o_data;
  
  //  For Adder
  wire                              adder_carry;
  wire signed [WIDTH - 1:0]         adder_out, data2;
  
  // For SLT
  wire signed [WIDTH - 1:0]         SLT_out;
  
  // For Logic Unit
  reg [WIDTH - 1:0]                 logic_out;
  
  // For shifter
  reg signed [WIDTH - 1:0]          shift_out;
  reg [62:0]                        extend_data;
  reg [46:0]                        shift_16;
  reg [38:0]                        shift_8;
  reg [34:0]                        shift_4;
  reg [32:0]                        shift_2;
  wire [4:0]                        shift_amount;
  
  
  
  // Logic Unit -----------------------------------------------------------------
  always @ *
  begin
    case(i_logic_op)
      AND:  logic_out = i_data1 & i_data2;
      OR:   logic_out = i_data1 | i_data2;
      NOR:  logic_out = ~(i_data1 | i_data2);
      XOR:  logic_out = i_data1 ^ i_data2;
    endcase
  end 
  // Logic Unit -----------------------------------------------------------------
  
  // Adder ----------------------------------------------------------------------
  param_adder  #(.WIDTH(WIDTH))inst_adder1  (
                                            .i_data1(i_data1), 
                                            .i_data2(data2), 
                                            .i_carry(i_arith_op), 
                                            .o_carry(adder_carry), 
                                            .o_data(adder_out)
                                            );  
  assign data2 = (i_data2 ^ {WIDTH{i_arith_op}});
  // Overflow for signed numbers or unsigned
  assign o_overflow =  inst_adder1.o_fcarry[WIDTH-2] ^ adder_carry ; 
  // Adder ----------------------------------------------------------------------
  
  // SLT ------------------------------------------------------------------------
  
  assign SLT_out = (i_sign) ? (adder_out[WIDTH - 1] ^ o_overflow) : !adder_carry;
  assign o_less = SLT_out;
  
  // SLT ------------------------------------------------------------------------
  
  // Shifter --------------------------------------------------------------------
  
  assign shift_amount = i_data1[4:0] ^ {5{|i_shift_op}};
   always @ *
  begin // Extender
    case(i_shift_op)
      SLL:  extend_data = {i_data2,{31{1'b0}}};
      SRL:  extend_data = {{31{1'b0}},i_data2};
      SRA:  extend_data = {{31{i_data2[31]}},i_data2};
      ROR:  extend_data = {i_data2[30:0], i_data2};
    endcase
  end // Extender
  
  always @ *
  begin
    case(shift_amount[4])
      0: shift_16 = extend_data[62:16];
      1: shift_16 = extend_data[46:0];
    endcase
    
    case(shift_amount[3])
      0:  shift_8 = shift_16[46:8];
      1:  shift_8 = shift_16[38:0];
    endcase
    
    case(shift_amount[2])
      0:  shift_4 = shift_8[38:4];
      1:  shift_4 = shift_8[34:0];
    endcase
    
    case(shift_amount[1])
      0:  shift_2 = shift_4[34:2];
      1:  shift_2 = shift_4[32:0];
    endcase
    
    case (shift_amount[0])
      0:  shift_out = shift_2[32:1];
      1:  shift_out = shift_2[31:0];
    endcase
  end
  
  // Shifter----------------------------------------
  
  // Output MUX ------------------------------------
  always @ *
  begin
    case (i_select)
      SHIFT:  o_data = shift_out;
      SLT:    o_data = SLT_out;
      ARITH:  o_data = adder_out;
      LOGIC:  o_data = logic_out;
    endcase
  end
  
  // Output MUX ------------------------------------
  
  assign o_zero = ~|o_data;
  
endmodule

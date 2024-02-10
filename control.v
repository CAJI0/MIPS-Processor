module Control_Logic 
(
i_op,
i_funct,
i_overflow,
i_inst_21,
i_inst_6,
o_Reg_Dst,
o_Ext_Op,
o_Reg_Write,
o_shift_mode,
o_ALU_Src,
o_ALU_select,
o_ALU_arith,
o_ALU_logic,
o_ALU_shift,
o_ALU_Sign,
o_Mem_Read,
o_Mem_Write,
o_Mem_to_Reg,
o_J,
o_Jr,
o_Beq,
o_Bne
);
  
  //  Control signals for o_shift_mode (MUX before first ALU input)
  parameter   SA = 0, // Shift amount from instruction
              BUS_A = 1,
              SHIFT_16 = 2;
  
  //  Control signals for o_ALU_Src (MUX before second ALU input)
  parameter   BUS_B = 0,
              IMM = 1;
              
  //  Control signals for o_Ext_Op            
  parameter   ZERO = 0,
              SIGN = 1;
              
  //  Control signals for ALU
  parameter   SLL = 0,
              SRL = 1,
              SRA = 2,
              ROR = 3;
  
  parameter   ADD = 0,
              SUB = 1;
  
  parameter   AND = 0,
              OR = 1,
              NOR = 2,
              XOR = 3;
            
  parameter   SHIFT = 0,
              SLT = 1,
              ARITH = 2,
              LOGIC = 3;
  
  input [5:0]       i_op, i_funct;
  input             i_overflow, i_inst_21, i_inst_6;
  output reg        o_Reg_Dst, o_Ext_Op, o_Reg_Write, o_ALU_Src, o_ALU_arith, o_ALU_Sign, o_Mem_Read, o_Mem_Write, o_Mem_to_Reg, o_J, o_Jr, o_Beq, o_Bne;
  output reg [1:0]  o_shift_mode, o_ALU_select, o_ALU_shift, o_ALU_logic;
              
              

always @* begin
  
  o_Reg_Dst = 1'bx;   
  o_Ext_Op = 1'bx;
  o_Reg_Write = 0;
  o_shift_mode = 2'bxx;
  
  o_ALU_Src = 1'bx;
  o_ALU_select = 2'bxx;
  o_ALU_shift = 2'bxx;
  o_ALU_arith = 1'bx;
  o_ALU_logic = 2'bxx;
  o_ALU_Sign = 1'bx;
  
  o_Mem_Read = 0;
  o_Mem_Write = 0;
  o_Mem_to_Reg = 1'bx;
  
  o_J = 0;
  o_Jr = 0;
  o_Beq = 0;
  o_Bne = 0;
  
  
case(i_op)
    6'b000000:  // R-type instruction
    begin       // Set default values 
      o_Reg_Dst = 1;       
      o_Reg_Write = 1;
      o_ALU_Src = BUS_B;
      o_shift_mode = BUS_A;
      o_Mem_to_Reg = 0;
      case(i_funct)
        6'b000000:  //  SLL
        begin
          o_ALU_select = SHIFT;
          o_ALU_shift = SLL;
          o_shift_mode = SA;
        end
        
        6'b000010:  //  SRL or ROTR
        begin
          if(i_inst_21)           // ROTR
          begin
            o_ALU_select = SHIFT;
            o_ALU_shift = ROR;
            o_shift_mode = SA;
          end
          else                  // SRL
          begin
            o_ALU_select = SHIFT;
            o_ALU_shift = SRL;
            o_shift_mode = SA;
          end
        end
        
        6'b000011:  //  SRA
        begin
          o_ALU_select = SHIFT;
          o_ALU_shift = SRA;
          o_shift_mode = SA;
        end
        
        6'b000100:  //  SLLV
        begin
          o_ALU_select = SHIFT;
          o_ALU_shift = SLL;
        end
        
        6'b000110:  // SRLV or ROTRV
        begin
          if(i_inst_6)  // ROTRV
          begin
            o_ALU_select = SHIFT;
            o_ALU_shift = ROR;
          end 
          else      // SRLV
          begin
            o_ALU_select = SHIFT;
            o_ALU_shift = SRL;
          end
        end
        
        6'b000111:  //  SRAV
        begin
          o_ALU_select = SHIFT;
          o_ALU_shift = SRA;
        end
        
        6'b001000:  // o_JR
        begin
          o_Jr = 1;
        end
        
        6'b100000:  //  ADD
        begin
          o_ALU_select = ARITH;
          o_ALU_arith = ADD;
          if(i_overflow)
            o_Reg_Write = 0;
        end
        
        6'b100001:  //  ADDU
        begin
          o_ALU_select = ARITH;
          o_ALU_arith = ADD;
        end
        
        6'b100010:  //  SUB
        begin
          o_ALU_select = ARITH;
          o_ALU_arith = SUB;
          if(i_overflow)
            o_Reg_Write = 0;
        end
        
        6'b100011:  //  SUBU
        begin
          o_ALU_select = ARITH;
          o_ALU_arith = SUB;
        end
        
        6'b100100:  // AND
        begin
          o_ALU_select = LOGIC;
          o_ALU_logic = AND;
        end
        
        6'b100101:  //  OR
        begin
          o_ALU_select = LOGIC;
          o_ALU_logic = OR;
        end
        
        6'b100110:  //  XOR
        begin
          o_ALU_select = LOGIC;
          o_ALU_logic = XOR;
        end
        
        6'b100111:  //  NOR
        begin
          o_ALU_select = LOGIC;
          o_ALU_logic = NOR;
        end
        
        6'b101010:  // SLT
        begin
          o_ALU_select = SLT;
          o_ALU_arith = SUB;
          o_ALU_Sign = 1;
        end
        
        6'b101011:  // SLTU
        begin
          o_ALU_select = SLT;
          o_ALU_arith = SUB;
          o_ALU_Sign = 0;   
        end
    
      endcase
    end
    
    6'b001000:  // ADDI
    begin
      o_Reg_Dst = 0;
      o_Ext_Op = SIGN;
      o_shift_mode = BUS_A;
      o_ALU_Src = IMM;
      o_ALU_select = ARITH;
      o_ALU_arith = ADD;
      o_Mem_to_Reg = 0;
      if(!i_overflow)
      o_Reg_Write = 1;
    end  
    
    6'b001001:  // ADDIU
    begin
      o_Reg_Dst = 0;
      o_Ext_Op = SIGN;
      o_Reg_Write = 1;
      o_shift_mode = BUS_A;
      o_ALU_Src = IMM;
      o_ALU_select = ARITH;
      o_ALU_arith = ADD;
      o_Mem_to_Reg = 0;
    end
    
    6'b001100:  //  ANDI
    begin
      o_Reg_Dst = 0;
      o_Ext_Op = ZERO;
      o_Reg_Write = 1;
      o_shift_mode = BUS_A;
      o_ALU_Src = IMM;
      o_ALU_select = LOGIC;
      o_ALU_logic = AND;
      o_Mem_to_Reg = 0;
    end
    
    6'b001101:  //  ORI
    begin
      o_Reg_Dst = 0;
      o_Ext_Op = ZERO;
      o_Reg_Write = 1;
      o_shift_mode = BUS_A;
      o_ALU_Src = IMM;
      o_ALU_select = LOGIC;
      o_ALU_logic = OR;
      o_Mem_to_Reg = 0;
    end
    
    6'b001110:  //  XORI
    begin
      o_Reg_Dst = 0;
      o_Ext_Op = ZERO;
      o_Reg_Write = 1;
      o_shift_mode = BUS_A;
      o_ALU_Src = IMM;
      o_ALU_select = LOGIC;
      o_ALU_logic = XOR;
      o_Mem_to_Reg = 0;
    end
    
    6'b001111:  //  LUI
    begin
      o_Reg_Dst = 0;
      o_Reg_Write = 1;
      o_shift_mode = SHIFT_16;
      o_ALU_Src = IMM;
      o_ALU_select = SHIFT;
      o_ALU_shift = SLL;
      o_Mem_to_Reg = 0;
    end
    
    6'b000010:  //  o_J
    begin
      o_J = 1;
    end
    
    6'b000100:  //  o_Beq
    begin
      o_ALU_Src = BUS_B;
      o_shift_mode = BUS_A;
      o_ALU_select = ARITH;
      o_ALU_arith = SUB;
      o_Beq = 1;
    end
    
    6'b000101:  //  o_Bne
    begin
      o_ALU_Src = BUS_B;
      o_shift_mode = BUS_A;
      o_ALU_select = ARITH;
      o_ALU_arith = SUB;
      o_Bne = 1;
    end
    
    6'b100011:  // LW
    begin
      o_Reg_Dst = 0;
      o_Ext_Op = SIGN;
      o_Reg_Write = 1;
      o_ALU_Src = IMM;
      o_shift_mode = BUS_A;
      o_ALU_select = ARITH;
      o_ALU_arith = ADD;
      o_Mem_Read = 1;
      o_Mem_to_Reg = 1;
    end
    
    6'b101011:  //  SW
    begin
      o_Ext_Op = 1;
      o_ALU_Src = IMM;
      o_shift_mode = BUS_A;
      o_ALU_select = ARITH;
      o_ALU_arith = ADD;
      o_Mem_Write = 1;
    end
    

  endcase
end
endmodule
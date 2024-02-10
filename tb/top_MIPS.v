module top (i_clk, i_rst_n);
  
  parameter                 WIDTH = 32;
  
  input                     i_clk, i_rst_n;
  
  wire [WIDTH - 1:0]          instruction_bus;
  wire signed [WIDTH - 1:0]   reg1_out, reg2_out;
  wire signed [WIDTH - 1:0]   extender_out;
  wire signed [WIDTH - 1:0]   ALU_data1_in, ALU_data2_in, ALU_result;
  wire signed [WIDTH - 1:0]   mem_data_to_reg, mem_data_out;
  
  wire [15:0]                 extender_in, imm16;
  wire [25:0]                 imm26;
  
  wire [29:0]                 inc_PC, Next_PC, next_pc;
  reg [29:0]                  PC_content;
  
  wire                        inst_6, inst_21;
  wire [4:0]                  Rs, Rt, Rd, Rw, shift_amount;
  wire [5:0]                  op, funct;
  
  wire                        Reg_Dst, Ext_Op, Reg_Write, 
                              ALU_Src, ALU_arith, ALU_Sign, 
                              Mem_Read, Mem_Write, Mem_to_Reg, 
                              J, Jr, Beq, Bne;
                              
  wire [1:0]                  shift_mode, ALU_select, ALU_shift, ALU_logic;
  wire                        ALU_zero, ALU_overflow, ALU_less;
  
  assign op = instruction_bus[31:26]; // op
  assign Rs = instruction_bus[25:21]; // Rs
  assign Rt = instruction_bus[20:16]; // Rt
  assign Rd = instruction_bus[15:11];  // Rd
  assign funct = instruction_bus[5:0];  // funct
  assign extender_in = instruction_bus[15:0];
  assign shift_amount = instruction_bus[10:6];  
  assign inst_6 = instruction_bus[5];   // For select: ROTRV or SLTV
  assign inst_21 = instruction_bus[20]; // For select: ROTR or SLT
  assign imm26 = instruction_bus[25:0];
  assign imm16 = instruction_bus[15:0];
  
  assign ALU_data1_in = (shift_mode == 0) ? shift_amount :
                        (shift_mode == 1) ? reg1_out: 32'd16 ;
  assign ALU_data2_in = (ALU_Src) ? extender_out : reg2_out; // Select Extender output or second output of reg file

  assign mem_data_to_reg = (Mem_to_Reg) ? mem_data_out : ALU_result;
  assign Rw = (Reg_Dst) ? Rd: Rt;
  
  ALU inst_ALU (
              .i_data1(ALU_data1_in), 
              .i_data2(ALU_data2_in), 
              .i_shift_op(ALU_shift), 
              .i_arith_op(ALU_arith), 
              .i_logic_op(ALU_logic), 
              .i_select(ALU_select), 
              .i_sign(ALU_Sign),
              .o_zero(ALU_zero), 
              .o_overflow(ALU_overflow),  
              .o_less(ALU_less),
              .o_data(ALU_result)
              );
              
  Reg_File inst_Reg_File (
              .i_data(mem_data_to_reg), 
              .i_we(Reg_Write), 
              .i_clk(i_clk), 
              .i_read_addr1(Rs), 
              .i_read_addr2(Rt), 
              .i_write_addr(Rw), 
              .o_data1(reg1_out), 
              .o_data2(reg2_out)
              );
  
  Next_PC inst_Next_PC (
              .i_inc_PC(inc_PC), 
              .i_imm26(imm26), 
              .i_reg_addr(reg1_out), 
              .i_J(J), 
              .i_Jr(Jr), 
              .i_Beq(Beq), 
              .i_Bne(Bne),
              .i_zero(ALU_zero), 
              .o_PCSrc(PCSrc), 
              .o_address(next_pc)
              );
  // Program counter            
  always @(posedge i_clk, negedge i_rst_n)
    begin
      if(!i_rst_n)
        PC_content <= 0;
      else
      PC_content <= Next_PC;
    end
  
  // Next PC
  assign inc_PC = PC_content + 1'b1;
  assign Next_PC = (PCSrc) ? next_pc : inc_PC;
  
  Instruction_Memory inst_Instruct_Mem (
              .i_address(PC_content), 
              .o_instruction(instruction_bus)
              );           
              
  Extender inst_Extender(
              .i_data(extender_in), 
              .i_ExOp(Ext_Op), 
              .o_data(extender_out)
              ); 
              
  Data_Memory inst_Data_Mem (
              .i_address(ALU_result), 
              .i_data(reg2_out), 
              .o_data(mem_data_out), 
              .i_clk(i_clk), 
              .i_we(Mem_Write), 
              .i_re(Mem_Read)
              );
              
  Control_Logic inst_Control_Logic(
              .i_op(op),
              .i_funct(funct),
              .i_overflow(ALU_overflow),
              .i_inst_21(inst_21),
              .i_inst_6(inst_6),
              .o_Reg_Dst(Reg_Dst),
              .o_Ext_Op(Ext_Op),
              .o_Reg_Write(Reg_Write),
              .o_shift_mode(shift_mode),
              .o_ALU_Src(ALU_Src),
              .o_ALU_select(ALU_select),
              .o_ALU_arith(ALU_arith),
              .o_ALU_logic(ALU_logic),
              .o_ALU_shift(ALU_shift),
              .o_Mem_Read(Mem_Read),
              .o_Mem_Write(Mem_Write),
              .o_Mem_to_Reg(Mem_to_Reg),
              .o_J(J),
              .o_Jr(Jr),
              .o_Beq(Beq),
              .o_Bne(Bne),
              .o_ALU_Sign(ALU_Sign)
              );
  
              
endmodule

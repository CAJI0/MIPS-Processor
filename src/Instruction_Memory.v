
module Instruction_Memory (i_address, o_instruction);
  
  parameter             WIDTH = 32;
            
  
  input [29:0]          i_address;
  output [WIDTH - 1:0]  o_instruction;
  
  reg [WIDTH - 1:0]     inst_mem [0: 2**30 - 1];
  
  
  assign o_instruction = inst_mem[i_address];
  
endmodule
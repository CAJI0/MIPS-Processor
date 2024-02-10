// Register file for MIPS
// Author: Karbivskyi O.
// Start data: 16.06.15

module Reg_File (i_data, i_we, i_clk, i_read_addr1, i_read_addr2, i_write_addr, o_data1, o_data2);
  
  parameter                       WIDTH = 32;
  
  input                           i_clk, i_we;
  input [4:0]                     i_read_addr1, i_read_addr2, i_write_addr;
  input signed[WIDTH - 1:0]       i_data;
  output reg signed[WIDTH - 1:0]  o_data1, o_data2;
  
  reg signed [WIDTH - 1:0]        reg_mem [1:31];

  always @ (posedge i_clk)
  if(i_we && (i_write_addr != 0))
    reg_mem[i_write_addr] <= i_data;
   
  always @ *
    if(i_read_addr1 == 0)
      o_data1 = 0;
    else
      o_data1 = reg_mem[i_read_addr1];
      
      
  always @ *
    if(i_read_addr2 == 0)
      o_data2 = 0;
    else
      o_data2 = reg_mem[i_read_addr2];
  
endmodule

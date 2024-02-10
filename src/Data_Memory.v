module Data_Memory (i_address, i_data, o_data, i_clk, i_we, i_re);
  
  parameter                   WIDTH = 32;
  
  input signed [WIDTH - 1:0]  i_data;
  input [WIDTH - 1:0]         i_address;
  input                       i_clk, i_we, i_re;
  
  output signed [WIDTH - 1:0] o_data;
  
  reg signed [WIDTH - 1:0]    data_mem [0:(2**31) - 1];
  
  always @ (posedge i_clk)
    if(i_we)
      data_mem[i_address] <= i_data;
      
  assign o_data = (i_re) ? data_mem[i_address] : 0;
  
endmodule

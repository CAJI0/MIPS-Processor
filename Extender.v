
module Extender (i_data, i_ExOp, o_data);
  
  parameter             WIDTH = 32;
  
  input [15:0]          i_data;
  input                 i_ExOp;
  output [WIDTH - 1:0]  o_data;
  
  wire control;
  
  assign control = i_data[15] & i_ExOp;
  assign o_data = {{WIDTH - 16{control}},i_data};
  
endmodule
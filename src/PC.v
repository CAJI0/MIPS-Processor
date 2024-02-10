module PC (i_clk, i_rst_n, o_address);
  
  parameter                 WIDTH = 32;
  
  input                     i_clk, i_rst_n;
  wire [WIDTH - 3:0]        address;
  output reg [WIDTH - 1:0]  o_address;
  
  assign address = o_address[WIDTH-1:2] + 1;
  
  always @ (posedge i_clk, negedge i_rst_n)
    if(!i_rst_n)
      o_address <= 0;
    else
      o_address <= {address, 2'b00};
    
    
  
endmodule
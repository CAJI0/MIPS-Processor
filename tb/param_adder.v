module param_adder(i_data1, i_data2, i_carry, o_carry, o_data);

parameter WIDTH = 4;

input                 i_carry;
input [WIDTH - 1:0]   i_data1, i_data2;
output                o_carry;
output [WIDTH - 1:0]  o_data;

wire [WIDTH - 2: 0]   o_fcarry;

genvar i;

generate 
  
  for(i = 0; i < WIDTH; i = i + 1)begin
    if(i == 0)
      
      full_adder u1 (i_data1[i], i_data2[i], i_carry, o_fcarry[i], o_data[i]);
      
    else if(i == WIDTH - 1)
      
      full_adder u2 (i_data1[i], i_data2[i], o_fcarry[i-1], o_carry, o_data[i]);
      
    else
      
      full_adder u3 (i_data1[i], i_data2[i], o_fcarry[i-1], o_fcarry[i], o_data[i]);
      
  end
  
endgenerate

endmodule
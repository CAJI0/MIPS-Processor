module half_adder (in1, in2, o_carry, o_sum);

input   in1, in2;
output  o_carry, o_sum;

and u1 (o_carry, in1, in2);
xor u2 (o_sum, in1, in2);

endmodule


module full_adder (in1, in2, i_carry, o_carry, o_sum);
  
  input   in1, in2, i_carry;
  output  o_carry, o_sum;
  wire    s1, c1, c2;
  
  half_adder u1(.in1(in1), .in2(in2), .o_carry(c1), .o_sum(s1));
  half_adder u2 (.in1(s1), .in2(i_carry), .o_carry(c2), .o_sum(o_sum));
  or u3 (o_carry, c1, c2);
     
endmodule
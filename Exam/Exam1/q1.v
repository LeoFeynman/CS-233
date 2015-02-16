// Design a circuit that takes three one-bit inputs
// and outputs two one-bit signals, where the outputs
// are defined by:

// - output "one" is true when exactly one input is true
// - output "two" is true when exactly two inputs are true

module one_two_set(one, two, a, b, c);
   output one, two;
   input a, b, c;
   wire not_a, not_b, not_c, o1, o2, o3, t1, t2, t3; 
  
   not n0(not_a, a);
   not n1(not_b, b);
   not n2(not_c, c);
   and a0(o1, not_a, not_b, c);
   and a1(o2, not_a, b, not_c);
   and a2(o3, a, not_b, not_c);
   and a3(t1, not_a, b, c);
   and a4(t2, a, not_b, c);
   and a5(t3, a, b, not_c);
   
   or or1(one, o1, o2, o3);
   or or2(two, t1, t2, t3);
 
endmodule // one_two_set


// Complete the sc2_block module in this file
// Don't put any code in this file besides the sc2_block

module sc2_block(s, cout, a, b, cin);
   output s, cout;
   input a, b, cin;
   wire w1, w2, w3;

   sc_block b1(w1, w2, a, b);
   sc_block b2(s, w3, cin, w1);
   or o2(cout, w2, w3);

endmodule // sc2_block

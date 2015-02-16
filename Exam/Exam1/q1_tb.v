module test;

   // these are inputs to "circuit under test"
   reg       a;
   reg       b;
   reg       c;
  // wires for the outputs of "circuit under test"
   wire       one;
   wire       two;
  // the circuit under test
   one_two_set o(one, two, a, b, c);  
    
   initial begin               // initial = run at beginning of simulation
                               // begin/end = associate block with initial
      
      $dumpfile("test.vcd");  // name of dump file to create
      $dumpvars(0, test);     // record all signals of module "test" and sub-modules
                              // remember to change "test" to the correct
                              // module name when writing your own test benches
        
      // test all input combinations
      a = 0; b = 0; c = 0; #10;
      a = 0; b = 0; c = 1; #10;
      a = 0; b = 1; c = 0; #10;
      a = 0; b = 1; c = 1; #10;
      a = 1; b = 0; c = 0; #10;
      a = 1; b = 0; c = 1; #10;
      a = 1; b = 1; c = 0; #10;
      a = 1; b = 1; c = 1; #10;
      
      $finish;        // end the simulation
   end                      
   
   initial begin
     $display("inputs = a, b, c  outputs = one, two");
     $monitor("inputs = %b  %b  %b  outputs = %b  %b   time = %2t",
              a, b, c, one, two, $time);
   end
endmodule // test

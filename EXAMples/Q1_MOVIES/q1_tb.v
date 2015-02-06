module test;

   // these are inputs to "circuit under test"
   reg       A;
   reg       F;
   reg [1:0] T;

  // wires for the outputs of "circuit under test"
   wire [1:0] M;

  // the circuit under test
   movies m(M, A, F, T);  
    
   initial begin               // initial = run at beginning of simulation
                               // begin/end = associate block with initial
      
      $dumpfile("test.vcd");  // name of dump file to create
      $dumpvars(0, test);     // record all signals of module "test" and sub-modules
                              // remember to change "test" to the correct
                              // module name when writing your own test benches
        
      // test all input combinations
      A = 0; F = 0; T = 0; #10;
      A = 0; F = 0; T = 1; #10;
      A = 0; F = 0; T = 2; #10;
      A = 0; F = 0; T = 3; #10;
      A = 0; F = 1; T = 0; #10;
      A = 0; F = 1; T = 1; #10;
      A = 0; F = 1; T = 2; #10;
      A = 0; F = 1; T = 3; #10;
      A = 1; F = 0; T = 0; #10;
      A = 1; F = 0; T = 1; #10;
      A = 1; F = 0; T = 2; #10;
      A = 1; F = 0; T = 3; #10;
      A = 1; F = 1; T = 0; #10;
      A = 1; F = 1; T = 1; #10;
      A = 1; F = 1; T = 2; #10;
      A = 1; F = 1; T = 3; #10;
      
      $finish;        // end the simulation
   end                      
   
   initial begin
     $display("inputs = A, F, T  outputs = M");
     $monitor("inputs = %d  %d  %d  outputs = %d   time = %2t",
              A, F, T, M, $time);
   end
endmodule // test

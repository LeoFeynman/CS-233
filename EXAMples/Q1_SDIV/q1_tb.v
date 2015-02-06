module test;

   // these are inputs to "circuit under test"
   reg [3:0] in;

  // wires for the outputs of "circuit under test"
   wire [2:0] out;

  // the circuit under test
   sdiv3 s(out, in);  
    
   initial begin               // initial = run at beginning of simulation
                               // begin/end = associate block with initial
      
      $dumpfile("test.vcd");  // name of dump file to create
      $dumpvars(0, test);     // record all signals of module "test" and sub-modules
                              // remember to change "test" to the correct
                              // module name when writing your own test benches
        
      // test all input combinations
      in = 0; #10;
      in = 1; #10;
      in = 2; #10;
      in = 3; #10;
      in = 4; #10;
      in = 5; #10;
      in = 6; #10;
      in = 7; #10;
      in = 8; #10;
      in = 9; #10;
      in = 10; #10;
      in = 11; #10;
      in = 12; #10;
      in = 13; #10;
      in = 14; #10;
      in = 15; #10;
      
      $finish;        // end the simulation
   end                      
   
   initial begin
     $display("inputs = in  outputs = out");
     $monitor("inputs = %d  outputs = %d   time = %2t",
              in, out, $time);
   end
endmodule // test

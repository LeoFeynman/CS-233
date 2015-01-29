module blackbox_test;

    reg u_in, l_in, s_in;
   
    wire r_out;

    blackbox bb2(r_out, u_in, l_in, s_in);

    initial begin
    
       $dumpfile("bb2.vcd");
       $dumpvars(0,blackbox_test);

       u_in = 0; l_in = 0; s_in = 0; # 10;
       u_in = 0; l_in = 0; s_in = 1; # 10;
       u_in = 0; l_in = 1; s_in = 0; # 10;
       u_in = 0; l_in = 1; s_in = 1; # 10;
       u_in = 1; l_in = 0; s_in = 0; # 10;
       u_in = 1; l_in = 0; s_in = 1; # 10;
       u_in = 1; l_in = 1; s_in = 0; # 10;
       u_in = 1; l_in = 1; s_in = 1; # 10;

       $finish; 
    end 

    initial 
      $monitor("At time %2t, u_in = %d l_in = %d s_in =%d r_out = %d",
               $time, u_in, l_in, s_in, r_out);

endmodule // blackbox_test

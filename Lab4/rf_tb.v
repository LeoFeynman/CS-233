module test;
    reg       clk = 0, enable = 0, reset = 1;  // start by reseting the register file

    /* Make a regular pulsing clock with a 10 time unit period. */
    always #5 clk = !clk;

    reg [4:0]    wr_regnum = 0, rd1_regnum = 0, rd2_regnum = 0;
    reg [31:0]   wr_data = 0;
    wire [31:0]  rd1_data, rd2_data;
    
    initial begin
        $dumpfile("rf.vcd");
        $dumpvars(0, test);
        # 10  reset = 0;      // stop reseting the RF

        # 700 $finish;
    end
    
    initial begin
    end

    mips_regfile rf (rd1_data, rd2_data, rd1_regnum, rd2_regnum, 
                     wr_regnum, wr_data, enable, clk, reset);
   
endmodule // test

module zero_checker_test;
    reg [31:0] in;

    initial begin
        $dumpfile("zero_checker.vcd");
        $dumpvars(0, zero_checker_test);

             in = 8;
        # 10 in = 31;
        # 10 in = 0;
        # 10 in = -1;
        # 10 $finish;
    end

    wire zero;
    zero_checker z(zero, in);
    initial
        $monitor("At time %2t, in = %d zero = %d", $time, in, zero);
endmodule

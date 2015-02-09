module i_reader_test;
    reg clk = 0;
    always #5 clk = !clk;

    reg [2:0] bits;
    reg       restart;

    initial begin
        $dumpfile("ir.vcd");
        $dumpvars(0, i_reader_test);

            restart = 1;
        # 13
            bits = 3'b111;
        # 4
            bits = 3'b000;       // not an I: restart is still 1
        # 5
            restart = 0;
        # 8
            bits = 3'b111;
        # 10
            bits = 3'b000;       // I
        # 10
            bits = 3'b111;
        # 20
            bits = 3'b000;       // not an I: sequence was 000, 111, 111, 000
        # 15
            $finish;
    end

    wire I;
    i_reader ir(I, bits, clk, restart);

    initial
        $monitor("Time %t: bits = %b I = %d restart = %d",
            $time, bits, I, restart);
endmodule // word_reader_test

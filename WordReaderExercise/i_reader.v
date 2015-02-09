// dffe: D-type flip-flop with enable
//
// q      (output) - Current value of flip flop
// d      (input)  - Next value of flip flop
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset   (reset =  1)
//
module dffe(q, d, clk, enable, reset);
    output q;
    reg    q;
    input  d;
    input  clk, enable, reset;

    always@(reset)
        if (reset == 1'b1)
            q <= 0;

    always@(posedge clk)
        if ((reset == 1'b0) && (enable == 1'b1))
            q <= d;
endmodule // dffe


module i_reader(I, bits, clk, restart);
    output      I;
    input [2:0] bits;
    input       restart, clk;
    wire        in000, in111,
                sBlank, sBlank_next,
                sI, sI_next,
                sI_end, sI_end_next,
                sGarbage, sGarbage_next;

    assign in000 = bits == 3'b000;
    assign in111 = bits == 3'b111;

    assign sBlank_next = (sBlank | sI_end | sGarbage) & in000;
    assign sI_next = (sBlank | sI_end) & in111;
    assign sI_end_next = sI & in000;
    assign sGarbage_next = ((sBlank | sI_end) & ~(in000 | in111)) | ((sI | sGarbage) & ~in000);

    // enable hardcoded to 1, reset hardcoded to 0
    dffe fsBlank(sBlank, sBlank_next, clk, 1'b1, 1'b0);
    dffe fsGarbage(sGarbage, sGarbage_next, clk, 1'b1, 1'b0);
    dffe fsI(sI, sI_next, clk, 1'b1, 1'b0);
    dffe fsI_end(sI_end, sI_end_next, clk, 1'b1, 1'b0);

    // outputs are associated with states, NOT transitions
    assign I = sI_end;
endmodule // word_reader

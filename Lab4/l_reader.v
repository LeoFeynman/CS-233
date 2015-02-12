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


module l_reader(L, bits, clk, restart);
    output      L;
    input [2:0] bits;
    input       restart, clk;
    wire        in000, in111, in001,
                sBlank, sBlank_next,
                sLA_next, sLB_next, sLA, sLB,
                sL_end, sL_end_next,
                sGarbage, sGarbage_next;
    
    assign in000 = bits == 3'b000;
    assign in111 = bits == 3'b111;
    assign in001 = bits == 3'b001;

    assign sGarbage_next = (sBlank & ~(in000 | in111)) | (sLA & ~ (in000 | in001)) | (sLB & ~ in000) | (sL_end & ~(in000 | in111)) | (sGarbage & ~in000); 
    assign sBlank_next = restart | ((sBlank | sL_end | sGarbage | sLA) & in000);
    assign sLA_next = (sBlank | sL_end) & in111;
    assign sLB_next = sLA & in001; 
    assign sL_end_next = sLB & in000; 
        
    dffe fsBlank(sBlank, sBlank_next, clk, 1'b1, 1'b0);
    dffe fsGarbage(sGarbage, sGarbage_next, clk, 1'b1, 1'b0);
    dffe fsLA(sLA, sLA_next, clk, 1'b1, 1'b0);
    dffe fsLB(sLB, sLB_next, clk, 1'b1, 1'b0);
    dffe fsL_end(sL_end, sL_end_next, clk, 1'b1, 1'b0);

    assign L = sL_end;
endmodule // l_reader


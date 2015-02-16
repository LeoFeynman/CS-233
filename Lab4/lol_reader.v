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


module lol_reader(L, O, Y, bits, clk, restart);
    output      L, O, Y;
    input [2:0] bits;
    input       restart, clk;
    wire        in000, in111, in001, in101, in100, in011,
                sBlank, sBlank_next,
                sLA_next, sLB_next, sOA_next, sOB_next, sOC_next, sYA_next, sYB_next, sYC_next,
		sLA, sLB, sOA, sOB, sOC, sYA, sYB, sYC,
                sL_end, sL_end_next, sO_end, sO_end_next, sY_end, sY_end_next,
                sGarbage, sGarbage_next;

    assign in000 = bits == 3'b000;
    assign in111 = bits == 3'b111;
    assign in001 = bits == 3'b001;
    assign in101 = bits == 3'b101;
    assign in100 = bits == 3'b100;
    assign in011 = bits == 3'b011;


    assign sGarbage_next = ~restart & ((sBlank & ~(in000 | in111 | in100)) | ((sL_end | sO_end) & ~(in000 | in111)) | (sLA & ~(in000 | in001)) | ((sLB | sOC) & ~in000) | (sGarbage & ~in000) | (sOA & ~(in101 | in000)) | sOB & ~in111 | (sYA & ~(in000 | in011)) | ((sYB | sY_end) & ~(in000|in100)) | (sYC & ~in000)); 

    assign sBlank_next = restart | ((sBlank | sL_end | sGarbage | sLA | sOA | sOB | sO_end | sYA | sYB | sY_end) & in000);

    assign sLA_next = ~restart & ((sBlank | sL_end) & in111);
    assign sLB_next = ~restart & (sLA & in001); 
    assign sL_end_next = ~restart & (sLB & in000); 
   
    assign sOA_next = ~restart & ((sBlank | sO_end) & in111);
    assign sOB_next = ~restart & (sOA & in101);
    assign sOC_next = ~restart & (sOB & in111);
    assign sO_end_next = ~restart & (sOC & in000);

    assign sYA_next = ~restart & ((sBlank | sY_end) & in100);
    assign sYB_next = ~restart & (sYA & in011);
    assign sYC_next = ~restart & (sYB & in100);
    assign sY_end_next = ~restart & (sYC & in000);
    
        
    dffe fsBlank(sBlank, sBlank_next, clk, 1'b1, 1'b0);
    dffe fsGarbage(sGarbage, sGarbage_next, clk, 1'b1, 1'b0);

    dffe fsLA(sLA, sLA_next, clk, 1'b1, 1'b0);
    dffe fsLB(sLB, sLB_next, clk, 1'b1, 1'b0);
    dffe fsL_end(sL_end, sL_end_next, clk, 1'b1, 1'b0);

    dffe fsOA(sOA, sOA_next, clk, 1'b1, 1'b0);
    dffe fsOB(sOB, sOB_next, clk, 1'b1, 1'b0);
    dffe fsOC(sOC, sOC_next, clk, 1'b1, 1'b0);
    dffe fsO_end(sO_end, sO_end_next, clk, 1'b1, 1'b0);

    dffe fsYA(sYA, sYA_next, clk, 1'b1, 1'b0);
    dffe fsYB(sYB, sYB_next, clk, 1'b1, 1'b0);
    dffe fsYC(sYC, sYC_next, clk, 1'b1, 1'b0);
    dffe fsY_end(sY_end, sY_end_next, clk, 1'b1, 1'b0);

    assign L = sL_end;
    assign O = sO_end;
    assign Y = sY_end;

endmodule // lol_reader

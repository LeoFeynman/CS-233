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
    wire        sBlank, sBlank_next;
    
    assign sBlank_next = restart;   // | other condition ... 
        
    dffe fsBlank(sBlank, sBlank_next, clk, 1'b1, 1'b0);
    
endmodule // l_reader

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
    wire        sNull, sNull_next;
    
    assign sNull_next = restart;   // | other condition ... 
        
    dffe fsNull(sNull, sNull_next, clk, 1'b1, 1'b0);
    
endmodule // lol_reader

module zero_checker(zero, in);
    output zero;
    input [31:0] in;
    wire  [31:1] chain;

    or o1(chain[1], in[1], in[0]);
    // or o2(chain[2], in[2], chain[1]);
    // or o3(chain[3], in[3], chain[2]);
    // ...
    not n0(zero, chain[31]);
endmodule

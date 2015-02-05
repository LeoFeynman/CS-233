// 00 - AND, 01 - OR, 10 - NOR, 11 - XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire l0, l1, l2, l3, not_control1, not_control2, w1, w2, w3, w4;

    and a1(l0, A, B);
    or o1(l1, A, B);
    nor n1(l2, A, B);
    xor x1(l3, A, B);
    //mux4 m1(out, l0, l1, l2, l3, control)
    not n2(not_control1, control[0]);
    not n3(not_control2, control[1]);
    and a2(w1, not_control1, not_control2, l0);
    and a3(w2, control[0], not_control2, l1);
    and a4(w3, not_control1, control[1], l2);
    and a5(w4, control[0], control[1], l3);
    or o2(out, w1, w2, w3, w4); 

    

endmodule // logicunit

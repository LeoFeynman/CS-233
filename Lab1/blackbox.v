module blackbox(r, u, l, s);
    output r;
    input  u, l, s;
    wire   w00, w01, w02, w03, w08, w09, w14, w18, w19, w30, w31, w35, w36, w72, w77, w86;

    and a22(r, w14, w30);
    or  o89(w14, w86, w02);
    and a45(w86, w31, w19);
    and a65(w02, w31, w00);
    not n47(w00, w19);
    or  o44(w30, w03, w08);
    not n64(w03, w08);
    and a7(w19, u, w01);
    or  o21(w01, w77, w72);
    not n87(w77, l);
    and a68(w72, w36, s);
    not n48(w36, s);
    and a46(w08, l, w35);
    or  o61(w35, u, s);
    and a23(w31, w09, w18);
    not n69(w09, u);
    or  o10(w18, l, s);

endmodule // blackbox

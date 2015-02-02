module steering(left, right, walk, sensors);
    output 	left, right, walk;
    input [4:0] sensors;
    wire ns0, ns1, ns2, ns3, ns4, w1, l1, l2, l3, l4, l5, l6, r1, r2, r3, r4;

    //walk section
    and a1(w1, sensors[1], sensors[2], sensors[3]);
    not n1(walk, w1);
 
    not n2(ns0, sensors[0]);
    not n3(ns1, sensors[1]);
    not n4(ns2, sensors[2]);
    not n5(ns3, sensors[3]);
    not n6(ns4, sensors[4]);
 
    //left section
    and a2(l1, ns4, ns3, sensors[2]);
    and a3(l2, ns4, sensors[3], sensors[2], ns1, sensors[0]);
    and a4(l3, ns4, sensors[3], sensors[2], sensors[1]); 
    and a5(l4, sensors[4], ns3, sensors[2], ns1, sensors[0]);
    and a6(l5, sensors[4], ns3, sensors[2], sensors[1]);
    and a7[l6, sensors[4], sensors[3], sensors[2], sensors[1], sensors[0]);
    or o1(left, l1, l2, l3, l4, l5, l6);
    
    //right section
    and a8(r1, ns4, sensors[3], sensors[2], ns1, ns0);
    and a9(r2, sensors[4], ns3, sensors[2], ns1, ns0);
    and a10(r3, sensors[4], sensors[3], sensors[2], ns1);
    and a11(r4, sensors[4], sensors[3], sensors[2], sensors[1], ns0);
    or o2(right, r1, r2, r3, r4);

endmodule // steering

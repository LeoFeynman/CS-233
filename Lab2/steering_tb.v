module steering_test;
 
    reg [4:0] sensors = 5'b0;
    
    initial begin
        $dumpfile("steering.vcd");  
        $dumpvars(0, steering_test);
        
        // if you're thinking "there has to be a better way to do this",
        // you're correct - we'll see it next week

        sensors[4:0] = 5'b00000; # 10;
        sensors[4:0] = 5'b00001; # 10;
        sensors[4:0] = 5'b00010; # 10;
        sensors[4:0] = 5'b00011; # 10;
        sensors[4:0] = 5'b00100; # 10;
        sensors[4:0] = 5'b00101; # 10;
        sensors[4:0] = 5'b00110; # 10;
        sensors[4:0] = 5'b00111; # 10;
        sensors[4:0] = 5'b01000; # 10;
        sensors[4:0] = 5'b01001; # 10;
        sensors[4:0] = 5'b01010; # 10;
        sensors[4:0] = 5'b01011; # 10;
        sensors[4:0] = 5'b01100; # 10;
        sensors[4:0] = 5'b01101; # 10;
        sensors[4:0] = 5'b01110; # 10;
        sensors[4:0] = 5'b01111; # 10;
        sensors[4:0] = 5'b10000; # 10;
        sensors[4:0] = 5'b10001; # 10;
        sensors[4:0] = 5'b10010; # 10;
        sensors[4:0] = 5'b10011; # 10;
        sensors[4:0] = 5'b10100; # 10;
        sensors[4:0] = 5'b10101; # 10;
        sensors[4:0] = 5'b10110; # 10;
        sensors[4:0] = 5'b10111; # 10;
        sensors[4:0] = 5'b11000; # 10;
        sensors[4:0] = 5'b11001; # 10;
        sensors[4:0] = 5'b11010; # 10;
        sensors[4:0] = 5'b11011; # 10;
        sensors[4:0] = 5'b11100; # 10;
        sensors[4:0] = 5'b11101; # 10;
        sensors[4:0] = 5'b11110; # 10;
        sensors[4:0] = 5'b11111; # 10;
 	
        $finish;              // end the simulation
    end                      
    
    wire left, right, walk;
    steering steer (left, right, walk, sensors);	
 
    initial
        $monitor("At time %t, sensors = %b left = %d right = %d walk = %d",
                 $time, sensors, left, right, walk);
endmodule // steering_test

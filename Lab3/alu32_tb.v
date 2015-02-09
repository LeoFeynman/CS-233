module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2
        # 10 A = 3; B = 7; control = `ALU_AND; // and operator
	# 10 A = 4; B = 2; control = `ALU_OR; // or operator
	# 10 A = 1; B = 8; control = `ALU_NOR; // nor operator
	# 10 A = 5; B = 6; control = `ALU_XOR; // xor operator
	# 10 A = 6; B = 6; control = `ALU_SUB; // gives zero
	# 10 A = 3; B = 32'h7FFFFFFF; control = `ALU_SUB; // negative = 1; overflow = 0
	# 10 A = 32'h7FFFFFFF; B = 32'h7FFFFFFF; control = `ALU_ADD; //addition overflow
	# 10 A = 32'hFF89B1E5; B = 32'hFFC9C825; control = `ALU_ADD; // adding two negative numbers of large magnitude
	# 10 A = 32'hFFC9C825; B = 32'h7FFFFFFF; control = `ALU_SUB; //subtracting a negative number of large magnitude from a large positive number
        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  
endmodule // alu32_test

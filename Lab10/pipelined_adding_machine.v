module pipelined_adding_machine(out, clk, reset);
   input         clk, reset;
   output [31:0] out;
   wire   [31:2] index, next_index;
   wire   [31:0] data, data_2, next_data;

   register #(30, 30'd0) Counter(index, next_index, clk, /* enable */1'b1, reset);
   adder30 Adder(next_index, index, 30'h1);
     
   adding_machine_memory rom (data, index);

   register #(32, 32'd0) Pipelining(data_2, data, clk, /* enable */1'b1, reset);

   alu32 alu(next_data, , `ALU_ADD, out, data_2);

   register #(32, 32'd0) Register(out, next_data, clk, /* enable */1'b1, reset);
   adder30 Adder2(next_index, index, 30'h1);



 
endmodule // pipelined_machine

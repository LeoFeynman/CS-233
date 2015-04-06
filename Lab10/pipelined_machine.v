module pipelined_machine(clk, reset);
   input        clk, reset;

   wire [31:0]  PC;
   wire [31:2]  next_PC, PC_plus4, PC_plus4_1, PC_target;
   wire [31:0]  inst, imm_1;
   
   wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
   wire [4:0]   rs = inst[25:21];
   wire [4:0]   rt = inst[20:16];
   wire [4:0]   rd = inst[15:11];
   wire [5:0]   opcode = inst[31:26];
   wire [5:0]   funct = inst[5:0];
   wire [5:0]   opcode_1, funct_1;

   wire [4:0]   wr_regnum, fw_wr_regnum, rd_1, rt_1, rs_1;
   wire [2:0]   ALUOp;

   wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
		fw_RegWrite, forwardA, forwardB;
   wire         PCSrc, zero, flush;
   wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data,
		rd1_data_1, rd2_data_1, fw_wr_data, A_data, B_data_in;

   assign flush = PCSrc || reset;
	

   register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */1'b1, reset);
   assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
   adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);

   register #(30) Pipelining_PC(PC_plus4_1, PC_plus4, clk, /* enable */1'b1, flush);

   adder30 target_PC_adder(PC_target, PC_plus4_1, imm_1[29:0]); //second adder
   mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
   assign PCSrc = BEQ & zero;
      
   instruction_memory imem (inst, PC[31:2]);

   register #(6) Pipelining_opcode(opcode_1, opcode, clk, /* enable */1'b1, flush);
   register #(6) Pipelining_funct(funct_1, funct, clk, /* enable */1'b1, flush);

   mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, opcode_1, funct_1);
   
   regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum, wr_data, 
               RegWrite, clk, reset);

   register #(32) Pipelining_rdData1(rd1_data_1, rd1_data, clk, /* enable */1'b1, flush);

   register #(32) Pipelining_rdData2(rd2_data_1, rd2_data, clk, /* enable */1'b1, flush);

   register #(32) Pipelining_imm(imm_1, imm, clk, /* enable */1'b1, flush);
   mux2v #(32) imm_mux(B_data, B_data_in, imm_1, ALUSrc);
   alu32 alu(alu_out_data, zero, ALUOp, A_data, B_data); 
   
   data_mem data_memory(load_data, alu_out_data, B_data_in, MemRead, MemWrite, clk, reset);
   
   mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);

   register #(5) Pipelining_rt(rt_1, rt, clk, /* enable */1'b1, flush);
   register #(5) Pipelining_rd(rd_1, rd, clk, /* enable */1'b1, flush);
   register #(5) Pipelining_rs(rs_1, rs, clk, /* enable */1'b1, flush);

   mux2v #(5) rd_mux(wr_regnum, rt_1, rd_1, RegDst);

   /*forwarding inputs*/
   register #(32) Forwarding_wr_data(fw_wr_data, wr_data, clk, /* enable */1'b1, reset);
   register #(5) Forwarding_wr_regnum(fw_wr_regnum, wr_regnum, clk, /* enable */1'b1, reset);
   register #(1) Forwarding_RegWrite(fw_RegWrite, RegWrite, clk, /* enable */1'b1, reset);
   
   /*forwarding mux*/
   mux2v #(32) FwA(A_data, rd1_data_1, fw_wr_data, forwardA);
   mux2v #(32) FwB(B_data_in, rd2_data_1, fw_wr_data, forwardB);

   /*forwarding unit*/
   assign forwardA = (rs_1 == fw_wr_regnum) && fw_RegWrite;
   assign forwardB = (rt_1 == fw_wr_regnum) && fw_RegWrite;
   

endmodule // pipelined_machine

// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clk     (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clk, reset);
    output      except;
    input       clk, reset;

    wire [31:0] inst, out, br_ofst, data_out, data_in, addr;  
    wire [31:0] PC, nextPC, imm32, PC4, branch_offset, jump, rsData, rtData, rdData, 
                mem_read_in, mem_read_out, slt_out,  bl_out, zeros, ngflag, lui_in, bl_in,
                B_in, B_out, addm_out;

    wire of, z, n, overflow, zero, negative, 
         writeenable, rd_src, alu_src2, except, 
         mem_read, word_we, byte_we, byte_load, lui, slt, addm;
    wire [7:0] doo;
    wire [4:0] Rdest;
    wire [2:0] alu_op;
    wire [1:0] control_type;

    assign jump[31:28] = PC[31:28];
    assign jump[27:2] = inst[25:0];
    assign jump[1] = 0;
    assign jump[0] = 0;
    assign ngflag[31:1] = zeros[31:1];
    assign ngflag[0] = negative;
    assign lui_in[31:16] = inst[15:0];
    assign lui_in[15:0] = zeros[15:0];
    assign bl_in[31:8] = zeros[31:8];
    assign bl_in[7:0] = doo;

    assign zeros[31] = 0;
    assign zeros[30] = 0;
    assign zeros[29] = 0;
    assign zeros[28] = 0;
    assign zeros[27] = 0;
    assign zeros[26] = 0;
    assign zeros[25] = 0;
    assign zeros[24] = 0;
    assign zeros[23] = 0;
    assign zeros[22] = 0;
    assign zeros[21] = 0;
    assign zeros[20] = 0;
    assign zeros[19] = 0;
    assign zeros[18] = 0;
    assign zeros[17] = 0;
    assign zeros[16] = 0;
    assign zeros[15] = 0;
    assign zeros[14] = 0;
    assign zeros[13] = 0;
    assign zeros[12] = 0;
    assign zeros[11] = 0;
    assign zeros[10] = 0;
    assign zeros[9] = 0;
    assign zeros[8] = 0;
    assign zeros[7] = 0;
    assign zeros[6] = 0;
    assign zeros[5] = 0;
    assign zeros[4] = 0;
    assign zeros[3] = 0;
    assign zeros[2] = 0;
    assign zeros[1] = 0;
    assign zeros[0] = 0;
    assign addr = out;
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clk, 1, reset);
    instruction_memory instMem(inst[31:0], PC[31:2]);
    regfile rf (rsData, rtData, inst[25:21], inst[20:16], Rdest, rdData, writeenable, clk, reset ); //register file
    mips_decode dc(alu_op, writeenable, rd_src, alu_src2, except, control_type, mem_read, word_we, byte_we, byte_load, lui, slt, addm, inst[31:26], inst[5:0], zero); // decoder
    data_mem dm(data_out, addr, rtData, word_we, byte_we, clk, reset); //data memory

    alu32 #(32) alu(out, overflow, zero, negative, rsData, B_out, alu_op);
    alu32 add4 (PC4, of, z, n, PC, 32'h4, 3'b010);//pc + 4
    alu32 #(32) offset(br_ofst, of, z, n, PC4, branch_offset, 3'b010); // taken beq/bne
    alu32 #(32) am(addm_out, of, z, n, rtData, data_out, 3'b010); //addm_alu

    mux2v #(5)  m0(Rdest, inst[15:11], inst[20:16], rd_src); // rd_src
    mux2v #(32) m1(B_in, rtData, imm32, alu_src2); //alu_src2
    mux4v #(32) m2(nextPC, PC4 , br_ofst, jump, rsData, control_type); //control_type
    mux2v #(32) m3(slt_out, out, ngflag, slt); //slt
    mux2v #(32) m4(bl_out, data_out, bl_in, byte_load); //byte_load
    mux2v #(32) m5(mem_read_out, slt_out, mem_read_in, mem_read); //mem_read
    mux2v #(32) m6(rdData, mem_read_out, lui_in, lui); //lui
    mux4v #(8)  m7(doo, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], out[1:0]); // lbu
    mux2v #(32) m8(mem_read_in, bl_out, addm_out, addm); //addm_mux
    mux2v #(32) m9(B_out, B_in, zeros, addm); //addm_mux


    // DO NOT comment out or rename this module
    // or the test bench will break
    sign_extender se(imm32 ,inst[15:0]);
    shift_left2 sl(branch_offset, imm32[29:0]);
    /* add other modules */

endmodule // full_machine

module sign_extender(out, in);
    output [31:0] out;
    input [15:0] in;

    assign out[15:0]=in[15:0];
    assign out[16]=in[15];
    assign out[17]=in[15];
    assign out[18]=in[15];
    assign out[19]=in[15];
    assign out[20]=in[15];
    assign out[21]=in[15];
    assign out[22]=in[15];
    assign out[23]=in[15];
    assign out[24]=in[15];
    assign out[25]=in[15];
    assign out[26]=in[15];
    assign out[27]=in[15];
    assign out[28]=in[15];
    assign out[29]=in[15];
    assign out[30]=in[15];
    assign out[31]=in[15];

endmodule // sign_extender

module shift_left2(out,in);
	output [31:0] out;
	input [29:0] in;
	assign out[31:2]=in[29:0];
	assign out[1]=0;
	assign out[0]=0;	
endmodule

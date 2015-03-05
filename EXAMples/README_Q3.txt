Q3 is a data path modification problem in Verilog.  

We'll provide you files like those in the Q3 directory, which consist
of:

	prompt.txt		(a description of what instruction 
				 to implement)

	machine.v		(a single-cycle machine for you to 
				 modify to add a new instruction)

	mips_defines.v		(verilog components; you shouldn't 
	modules.v		 need to edit these, but you can if 
	mux_lib.v  		 you want.)
	rom.v

	machine_tb.v		(a standard testbench)

	Makefile				

	test.s			(a test that includes the instruction
	test.data.dat		 that you are supposed to implement.)
	test.text.dat

	regression.s		(a regression test consisting of the 
	regression.data.dat	 instructions that the machine already
	regression.text.dat	 implements to help you know if you 
				 broke the existing functionality.)

	MIPSGreenSheet.pdf	(for your reference)

	single_cycle.pdf	(we'll provide you this in hardcopy so
				 you can draw your circuit before coding it.)

(Note: this file will not be provided.  Study it now and learn how to
do this exam _before_ you go to the exam.  :)

My suggestion of how to solve this problem on the exam.

1. read the prompt and figure out what the desired outputs of the test.s
   input are.  You need to understand what you are trying to implement.

2. design the circuit on paper

3. make a copy of the original 'machine.v' (and any other verilog file 
   that you change), so you can later diff your modified version with 
   it, if you end up breaking anything.  You could use svn or git to make
   this copy, if you are particularly awesome.

4. run:    
   	   make regression
	   make > regress

   this will run the base verilog against the regression inputs and save
   the result in a file called 'regress'.  This way you know what the 
   outputs of the regression tests should be and when you are done, you
   can verify that you didn't break anything.

5. modify 'machine.v' to implement the changes you drew on paper.

6. run:
	   make test
	   make

   this runs your verilog against the test input that has your instruction.
   If the results are not what you expected them to be from step 1, then
   I suggest firing up gtkwave to trace down your errors, especially if
   you are getting X's or Z's in register values.  Start by looking
   at the values going into the register file and trace them backward
   until you find the first spot where they go bad.

   at any point it can be useful to review the changes that you made to 
   see if you did something stupid.  An efficent way to do that is to 
   diff your modified file against the original

   	  diff machine.v orig_machine.v

   (where 'orig_machine.v' is whatever you called the copy you made in 
   step 3.  If you used svn or git, then use 'svn diff' or 'git diff'.)

7. when your test input is working, run: 

   	   make regression
	   make > regress.new
	   diff regress.new regress

   like step 4, this will run the regression test, but in addition compare
   your new results to what they should be.  Fix any bugs.

8. celebrate a job well done.


We've provided two example problems: 'lhu' and 'jalr' in Q3_LHU and
Q3_JALR.  In those directories, we've put the prompts, tests,
drawings, and solution machine.v files.  You are encouraged to try to
solve these problems before looking at their solutions.  You can do
this by looking at the prompt in those directories and copying test.*
from each one of the directories to your Q3 directory and doing the
implementation there.

You can look at the modifications that we performed by diff'ing the 
solution 'machine.v' with the original one that we provided in the
Q3 directory.


		







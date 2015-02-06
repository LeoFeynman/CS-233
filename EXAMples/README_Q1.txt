Q1, the only long form question for the first exam, asks you to complete a
verilog module for a combinational circuit.  The desired circuit is 
described in English.  The question that you'll be asked will be drawn 
from one of two main types: arithmetic/MSI and story.  We've provided
one example problem from each class

Arithmetic/MSI problems (e.g. Q1_SDIV) ask you to build a circuit that
performs a simple arithmetic function (signed/unsigned 
addition/subtraciton/multiplication/division/square/square root/etc.)
or build a simple "medium scale integration" component (e.g, 
multiplexor, decoder, encoder) from a short description.  These
problems often rely on your understanding about how binary arithmetic
works.

Story problems (e.g., Q1_MOVIES) don't rely on your understanding 
of arithmetic or other components, and, therefore, typically involve
a longer narative to explain how the output should be generated as
function of the inputs.

The problems Q1_SDIV and Q1_MOVIES were problems taken from actual
previous CS 233 exams, and we will provide solutions to the questions 
in the form of correct truth tables and boolean expressions.

In the actual exam, you will need to check out your exam problem from
a special SVN server.  After completing the test, IT IS OF THE UTMOST
IMPORTANCE THAT YOU CHECK YOUR CODE BACK IN TO SVN.  Failure to do so 
will result in a 0 grade.

The code will consist of a Q1 directory with contents like the Q1_SDIV
and Q1_MOVIES directories, which will include a directions file
which will contains the following.  (Updated with any clarifications.)

---------------------------------------------------------------------------

WHEN YOU WRITE YOUR VERILOG, YOU SHOULD LIMIT YOURSELF TO:

1. primitive gates: and, or, not, xor, nor, nand   (as many inputs as you want)
  
     -- and --

2. assign statements using the &, |, ~, !, ^, ==, and != operators

3. bus selection (e.g., x[1]) and concatenation (e.g., { x[1], y[2] })

4. verilog constants (e.g., 2'b10, 6'h37)

USE OF ANY OTHER OPERATORS IN YOUR SUBMITTED CODE WILL RESULT IN A
ZERO ON THE PROBLEM.

We provide a test bench that exhaustively tests your code.  You can compile
your code with the provided test bench with the following command:

     iverilog -Wall -o q1 q1.v q1_tb.v

which will generate an executable called 'q1' which can then be executed
by the following command:

     ./q1



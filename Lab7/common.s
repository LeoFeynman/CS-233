# syscall constants
PRINT_INT = 1
PRINT_STRING = 4
PRINT_CHAR = 11

.data

# global variables (puke) ##############################################

.globl puzzle
puzzle:
	.word 0

.globl num_rows
num_rows:
	.word 0

.globl num_columns
num_columns:
	.word 0

# puzzles ##############################################################
.globl puzzle_1
.align 2
puzzle_1:
	.ascii "XDTUOHTIWEZGCDHN"
	.ascii "DLANGUAGEDUWCPQG"
	.ascii "EOADHSILGNERWNQH"
	.ascii "ILJFNHORIZONTALA"
	.ascii "NHDAKJBSELFIETGD"
	.ascii "ACPCBDGEHELLONGV"
	.ascii "PROCVKZBVSKNAHTB"
	.ascii "MASOXSHYBMOLLEHE"
	.ascii "OETMTKGMOIXFROMD"
	.ascii "CSIPRNXEIJACEUWA"
	.ascii "CENAEASIKFGHKMCM"
	.ascii "ARGNNHEFFDMYYYQX"
	.ascii "OTBIDTGLLGOJBVIZ"
	.ascii "AKBEXEAEVQGTDQMR"
	.ascii "LJODSHPSHTQEVRIL"
	.ascii "GHEIWUGUANROSAGH"

.globl puzzle_2
.align 2
puzzle_2:
	.ascii "EGAUGNALLMICYQLB"
	.ascii "QRETTIWTEPXSZJLF"
	.ascii "RCSWITHOUTGEKDPE"
	.ascii "CLGBPTNEDISERPUR"
	.ascii "ESEEFHCUSVDIHRIM"
	.ascii "LTHKLUNCYDALCZGC"
	.ascii "ERTEUTAGOBAMAYGW"
	.ascii "BESMLCMSUCHIPHGA"
	.ascii "RNZAAWTAWORDLFZY"
	.ascii "IDPGNEHMOFNEGKMF"
	.ascii "TKQAGEEAERHKQJDK"
	.ascii "IZFZUKABWXYXAUPM"
	.ascii "ECRIAGIOIDRHDWSN"
	.ascii "SFONGNQAMAUHSBYY"
	.ascii "KXMEEISSBFNALTRX"
	.ascii "OTHJODBFNJWJOIEG"

# dictionary ###########################################################
.globl english
english:
	.word word_HELLO
	.word word_GOODBYE
	.word word_THANKS
	.word word_YOUR
	.word word_HAT
	.word word_HORIZONTAL
	.word word_SOARING
	.word word_RESEARCH
	.word word_FREQUENCY
	.word word_SELFIE
	.word word_ENGLISH
	.word word_LANGUAGE
	.word word_INCREASED
	.word word_LAST
	.word word_WORD
	.word word_CRITICS
	.word word_SURVEY
	.word word_TIME
	.word word_MAGAZINE
	.word word_POPULARITY
	.word word_HAS
	.word word_BEEN
	.word word_ACCOMPANIED
	.word word_BY
	.word word_EVERYONE
	.word word_FROM
	.word word_THE
	.word word_POPE
	.word word_TO
	.word word_PRESIDENT
	.word word_OBAMA
	.word word_TAKING
	.word word_PART
	.word word_TREND
	.word word_BARELY
	.word word_WEEK
	.word word_GOES
	.word word_WITHOUT
	.word word_CELEBRITIES
	.word word_SUCH
	.word word_JUSTIN
	.word word_BIEBER
	.word word_LADY
	.word word_GAGA
	.word word_AND
	.word word_RIHANNA
	.word word_POSTING
	.word word_SELFIES
	.word word_THEIR
	.word word_TWITTER
	.word word_PAGES
	.word word_BUT
.globl english_size
english_size: .word (english_size - english) / 4


.text
# print int and space ##################################################
#
# argument $a0: number to print
# returns       nothing

.globl print_int_and_space
print_int_and_space:
	li	$v0, PRINT_INT	# load the syscall option for printing ints
	syscall			# print the number

	li   	$a0, ' '       	# print a black space
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure

# print char and space #################################################
#
# argument $a0: character to print
# returns       nothing

.globl print_char_and_space
print_char_and_space:
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the number

	li   	$a0, ' '       	# print a black space
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure

# print string #########################################################
#
# argument $a0: string to print
# returns       nothing

.globl print_string
print_string:
	li	$v0, PRINT_STRING	# print string command
	syscall	     			# string is in $a0
	jr	$ra

# print newline ########################################################
#
# no arguments
# returns       nothing

.globl print_newline
print_newline:
	li   	$a0, '\n'      	# print a newline
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	jr	$ra

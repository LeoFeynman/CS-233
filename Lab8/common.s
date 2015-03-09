# syscall constants
PRINT_INT = 1
PRINT_STRING = 4
SBRK = 9
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

word_HELLO:       .asciiz "HELLO"
word_GOODBYE:     .asciiz "GOODBYE"
word_THANKS:      .asciiz "THANKS"
word_YOUR:        .asciiz "YOUR"
word_HAT:         .asciiz "HAT"
word_HORIZONTAL:  .asciiz "HORIZONTAL"
word_SOARING:     .asciiz "SOARING"
word_RESEARCH:    .asciiz "RESEARCH"
word_FREQUENCY:   .asciiz "FREQUENCY"
word_SELFIE:      .asciiz "SELFIE"
word_ENGLISH:     .asciiz "ENGLISH"
word_LANGUAGE:    .asciiz "LANGUAGE"
word_INCREASED:   .asciiz "INCREASED"
word_LAST:        .asciiz "LAST"
word_WORD:        .asciiz "WORD"
word_CRITICS:     .asciiz "CRITICS"
word_SURVEY:      .asciiz "SURVEY"
word_TIME:        .asciiz "TIME"
word_MAGAZINE:    .asciiz "MAGAZINE"
word_POPULARITY:  .asciiz "POPULARITY"
word_HAS:         .asciiz "HAS"
word_BEEN:        .asciiz "BEEN"
word_ACCOMPANIED: .asciiz "ACCOMPANIED"
word_BY:          .asciiz "BY"
word_EVERYONE:    .asciiz "EVERYONE"
word_FROM:        .asciiz "FROM"
word_THE:         .asciiz "THE"
word_POPE:        .asciiz "POPE"
word_TO:          .asciiz "TO"
word_PRESIDENT:   .asciiz "PRESIDENT"
word_OBAMA:       .asciiz "OBAMA"
word_TAKING:      .asciiz "TAKING"
word_PART:        .asciiz "PART"
word_TREND:       .asciiz "TREND"
word_BARELY:      .asciiz "BARELY"
word_WEEK:        .asciiz "WEEK"
word_GOES:        .asciiz "GOES"
word_WITHOUT:     .asciiz "WITHOUT"
word_CELEBRITIES: .asciiz "CELEBRITIES"
word_SUCH:        .asciiz "SUCH"
word_JUSTIN:      .asciiz "JUSTIN"
word_BIEBER:      .asciiz "BIEBER"
word_LADY:        .asciiz "LADY"
word_GAGA:        .asciiz "GAGA"
word_AND:         .asciiz "AND"
word_RIHANNA:     .asciiz "RIHANNA"
word_POSTING:     .asciiz "POSTING"
word_SELFIES:     .asciiz "SELFIES"
word_THEIR:       .asciiz "THEIR"
word_TWITTER:     .asciiz "TWITTER"
word_PAGES:       .asciiz "PAGES"
word_BUT:         .asciiz "BUT"

# miscellaneous data ###################################################

null_str:
	.asciiz "(null)"


.text
# print int and space ##################################################
#
# argument $a0: number to print
# returns       nothing

.globl print_int_and_space
print_int_and_space:
	li	$v0, PRINT_INT	# load the syscall option for printing ints
	syscall			# print the number
	j	print_space

# print int and newline ################################################
#
# argument $a0: number to print
# returns       nothing

.globl print_int_and_newline
print_int_and_newline:
	li	$v0, PRINT_INT	# load the syscall option for printing ints
	syscall			# print the number
	j	print_newline

# print char and space #################################################
#
# argument $a0: character to print
# returns       nothing

.globl print_char_and_space
print_char_and_space:
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the number
	j	print_space

# print string and space ###############################################
#
# argument $a0: string to print
# returns       nothing

.globl print_string_and_space
print_string_and_space:
	la	$a1, print_space
	j	print_string

# print string and newline #############################################
#
# argument $a0: string to print
# returns       nothing

.globl print_string_and_newline
print_string_and_newline:
	la	$a1, print_newline
	# fall through to print_string

# print string #########################################################
#
# argument $a0: string to print
# argument $a1: continuation
# returns       nothing

print_string:
	la	$t0, null_str
	movz	$a0, $t0, $a0		# $a0 = $t0 if $a0 == 0 (NULL)
	li	$v0, PRINT_STRING	# print string command
	syscall	     			# string is in $a0
	jr	$a1

# print space ##########################################################
#
# no arguments
# returns       nothing

print_space:
	li   	$a0, ' '      	# print a space
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	jr	$ra

# print newline ########################################################
#
# no arguments
# returns       nothing

print_newline:
	li   	$a0, '\n'      	# print a newline
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	jr	$ra

# alloc trie ###########################################################
#
# no arguments
# returns       the allocated trie node

.globl alloc_trie
alloc_trie:
	li	$v0, SBRK
	li	$a0, 108		# sizeof(trie_t)
	syscall				# $v0 = ret_val

	sw	$zero, 0($v0)		# ret_val->word = NULL
	li	$t0, 0			# i = 0

at_loop:
	mul	$t1, $t0, 4		# i * 4
	add	$t1, $v0, $t1		# &ret_val->next[i] - 4
	sw	$zero, 4($t1)		# ret_val->next[i] = NULL
	add	$t0, $t0, 1		# i ++
	blt	$t0, 26, at_loop	# i < 26

	jr	$ra

.text

## char
## get_character(int i, int j) {
##     return puzzle[i * num_columns + j];
## }

.globl get_character
get_character:
	jr	$ra


## int
## horiz_strncmp(const char* word, int start, int end) {
##     int word_iter = 0;
## 
##     while (start <= end) {
##         if (puzzle[start] != word[word_iter]) {
##             return 0;
##         }
## 
##         if (word[word_iter + 1] == '\0') {
##             return start;
##         }
## 
##         start++;
##         word_iter++;
##     }
##     
##     return 0;
## }

.globl horiz_strncmp
horiz_strncmp:
	jr	$ra

// To compile and run:
// clang++ -Wall -o puzzle_solver puzzle_solver.cpp
// ./puzzle_solver

#include <stdio.h>

// 16 by 16
const char* puzzle_1 =  "XDTUOHTIWEZGCDHN"
                        "DLANGUAGEDUWCPQG"
                        "EOADHSILGNERWNQH"
                        "ILJFNHORIZONTALA"
                        "NHDAKJBSELFIETGD"
                        "ACPCBDGEHELLONGV"
                        "PROCVKZBVSKNAHTB"
                        "MASOXSHYBMOLLEHE"
                        "OETMTKGMOIXFROMD"
                        "CSIPRNXEIJACEUWA"
                        "CENAEASIKFGHKMCM"
                        "ARGNNHEFFDMYYYQX" 
                        "OTBIDTGLLGOJBVIZ"
                        "AKBEXEAEVQGTDQMR"
                        "LJODSHPSHTQEVRIL"
                        "GHEIWUGUANROSAGH";

const char* puzzle_2 =  "EGAUGNALLMICYQLB"
                        "QRETTIWTEPXSZJLF"
                        "RCSWITHOUTGEKDPE"
                        "CLGBPTNEDISERPUR"
                        "ESEEFHCUSVDIHRIM"
                        "LTHKLUNCYDALCZGC"
                        "ERTEUTAGOBAMAYGW"
                        "BESMLCMSUCHIPHGA"
                        "RNZAAWTAWORDLFZY"
                        "IDPGNEHMOFNEGKMF"
                        "TKQAGEEAERHKQJDK"
                        "IZFZUKABWXYXAUPM"
                        "ECRIAGIOIDRHDWSN"
                        "SFONGNQAMAUHSBYY"
                        "KXMEEISSBFNALTRX"
                        "OTHJODBFNJWJOIEG";

// 52 words
const char* english[] = {"HELLO", "GOODBYE", "THANKS", "YOUR", "HAT", "HORIZONTAL", 
    "SOARING" ,"RESEARCH","FREQUENCY","SELFIE" ,"ENGLISH" ,"LANGUAGE","INCREASED",
    "LAST","WORD" ,"CRITICS" ,"SURVEY" ,"TIME","MAGAZINE","POPULARITY","HAS",
    "BEEN","ACCOMPANIED","BY","EVERYONE","FROM","THE","POPE","TO","PRESIDENT",
    "OBAMA","TAKING","PART","TREND","BARELY","WEEK","GOES","WITHOUT","CELEBRITIES",
    "SUCH","JUSTIN","BIEBER","LADY","GAGA","AND","RIHANNA","POSTING","SELFIES","THEIR",
    "TWITTER","PAGES","BUT"};


const char* puzzle = NULL;
int num_rows = 0;
int num_columns = 0;

char
get_character(int i, int j) {
    return puzzle[i * num_columns + j];
}

int
horiz_strncmp(const char* word, int start, int end) {
    int word_iter = 0;

    while (start <= end) {
        if (puzzle[start] != word[word_iter]) {
            return 0;
        }

        if (word[word_iter + 1] == '\0') {
            return start;
        }

        start++;
        word_iter++;
    }
    
    return 0;
}

int
vert_strncmp(const char* word, int start_i, int j) {
    int word_iter = 0;

    for (int i = start_i; i < num_rows; i++, word_iter++) {
        if (get_character(i, j) != word[word_iter]) {
            return 0;
        }

        if (word[word_iter + 1] == '\0') {
            // return ending address within array
            return i * num_columns + j;
        }
    }

    return 0;
}

// assumes the word is at least 4 characters
int
horiz_strncmp_fast(const char* word) {
    // treat first 4 chars as an int
    unsigned x = *(unsigned*)word;
    unsigned cmp_w[4];
    // compute different offsets to search
    cmp_w[0] = x;
    cmp_w[1] = (x & 0x00ffffff); 
    cmp_w[2] = (x & 0x0000ffff);
    cmp_w[3] = (x & 0x000000ff);

    for (int i = 0; i < num_rows; i++) {
        // treat the row of chars as a row of ints
        unsigned* array = (unsigned*)(puzzle + i * num_columns);
        for (int j = 0; j < num_columns / 4; j++) {
            unsigned cur_word = array[j];
            int start = i * num_columns + j * 4;
            int end = (i + 1) * num_columns - 1;

            // check each offset of the word
            for (int k = 0; k < 4; k++) {
                // check with the shift of current word
                if (cur_word == cmp_w[k]) {
                    // finish check with regular horiz_strncmp
                    int ret = horiz_strncmp(word, start + k, end);
                    if (ret != 0) {
                        return ret;
                    }
                }
                cur_word >>= 8;
            }
        }
    }
    
    return 0;
}

int main()
{
    puzzle = puzzle_1;
    num_rows = 16;
    num_columns = 16;

    // part 1 tests
    char c = get_character(0, 5);
    printf("%c ", c);
    c = get_character(4, 11);
    printf("%c ", c);

    int e = horiz_strncmp("SELFIE", 71, 79);
    printf("%d ", e);
    e = horiz_strncmp("SELFIE", 0, 15);
    printf("%d\n", e);

    // part 2 tests
    e = vert_strncmp("POSTING", 5, 2);
    printf("%d ", e);
    e = vert_strncmp("POSTING", 8, 8);
    printf("%d ", e);

    e = horiz_strncmp_fast("LANGUAGE");
    printf("%d ", e);
    e = horiz_strncmp_fast("NOTAWORD");
    printf("%d\n", e);
}

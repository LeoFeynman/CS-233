// To compile and run:
// clang++ -Wall -o puzzle_solver puzzle_solver.cpp
// ./puzzle_solver

#include <stdio.h>

struct word_instance {
    const char* word;
    int start;
    int end;
    word_instance* next;
};

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
word_instance* words = NULL;
word_instance** words_end = &words;

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

void
record_word(const char* word, int start, int end) {
    word_instance* new_word = new word_instance;
    new_word->word = word;
    new_word->start = start;
    new_word->end = end;
    new_word->next = NULL;
    *words_end = new_word;
    words_end = &new_word->next;
}

void
find_words(const char** dictionary, int dictionary_size) {
    for (int i = 0; i < num_rows; i++) {
        for (int j = 0; j < num_columns; j++) {
            int start = i * num_columns + j;
            int end = (i + 1) * num_columns - 1;

            for (int k = 0; k < dictionary_size; k++) {
                const char* word = dictionary[k];
                int word_end = horiz_strncmp(word, start, end);
                if (word_end > 0) {
                    record_word(word, start, word_end);
                }

                word_end = vert_strncmp(word, i, j);
                if (word_end > 0) {
                    record_word(word, start, word_end);
                }
            }
        }
    }
}

int
main() {
    puzzle = puzzle_1;
    num_rows = 16;
    num_columns = 16;

    find_words(english, sizeof(english) / sizeof(*english));
    for (const word_instance* word = words; word != NULL; word = word->next) {
        printf("%s %d %d\n", word->word, word->start, word->end);
    }
}

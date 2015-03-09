// compile and run using
// clang++ -Wall -o trie trie.cpp
// ./trie

#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

// 52 words
const char* english[] = {"HELLO", "GOODBYE", "THANKS", "YOUR", "HAT", "HORIZONTAL", 
    "SOARING" ,"RESEARCH","FREQUENCY","SELFIE" ,"ENGLISH" ,"LANGUAGE","INCREASED",
    "LAST","WORD" ,"CRITICS" ,"SURVEY" ,"TIME","MAGAZINE","POPULARITY","HAS",
    "BEEN","ACCOMPANIED","BY","EVERYONE","FROM","THE","POPE","TO","PRESIDENT",
    "OBAMA","TAKING","PART","TREND","BARELY","WEEK","GOES","WITHOUT","CELEBRITIES",
    "SUCH","JUSTIN","BIEBER","LADY","GAGA","AND","RIHANNA","POSTING","SELFIES","THEIR",
    "TWITTER","PAGES","BUT"};

struct trie_t {
    const char *word;
    trie_t *next[26];
};

trie_t *
alloc_trie() {
    trie_t *ret_val = new trie_t;
    ret_val->word = NULL;
    for (int i = 0 ; i < 26 ; i ++) {
        ret_val->next[i] = NULL;
    }
    return ret_val;
}

void
add_word_to_trie(trie_t *trie, const char *word, int index) {
    char c = word[index];
    if (c == 0) {
        trie->word = word;
        return;
    }

    if (trie->next[c - 'A'] == NULL) {
        trie->next[c - 'A'] = alloc_trie();
    }
    add_word_to_trie(trie->next[c - 'A'], word, index + 1);
}

trie_t *
build_trie(const char **wordlist, int num_words) {
    trie_t *root = alloc_trie();

    for (int i = 0 ; i < num_words ; i ++) {
        // start at first letter of each word
        add_word_to_trie(root, wordlist[i], 0);
    }

    return root;
}

const char *
lookup_word_in_trie(trie_t *trie, const char *word) {
    if (trie == NULL) {
        return NULL;
    }

    if (trie->word) {
        return trie->word;
    }

    int c = *word - 'A';
    if (c < 0 || c >= 26) {
        return NULL;
    }

    trie_t *next_trie = trie->next[c];
    word ++;
    return lookup_word_in_trie(next_trie, word);
}

int
main() {
    trie_t *root = build_trie(english, 52);
    const char *str = "FOOBARPOSTINGOESELFIEVERYONERHINOCEROUS";
    while (*str != 0) {
        const char *word_found = lookup_word_in_trie(root, str);
        if (word_found != NULL) {
            printf("%s\n", word_found);
        }
        str ++;
    }
}

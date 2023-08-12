#include <stdio.h>
#include <stdlib.h>
#include <locale.h>

int count_wide_char(char *str);

int main(int argc, char *argv[]) {
    if (argc == 1) {
        printf("Please input a string.\n");
        return 1;
    }
    char *my_string = argv[1];
    int wlen = count_wide_char(my_string);
    int ascii_count = 0;

    for (int i = 0; my_string[i] != '\0'; i++) {
        int ch = my_string[i];
        if (ch >= 0 && ch <= 127) {
            ascii_count++;
        }
    }
    int terminal_print_width = ( wlen - ascii_count ) + wlen;

    printf("%d\n", terminal_print_width);

    return 0;
}

int count_wide_char(char *str) {
    setlocale(LC_ALL, ""); // Set the locale to the user's default for wide character support

    // Convert the character string to a wide character string
    size_t wstr_len = mbstowcs(NULL, str, 0);

    return (int) wstr_len;
}

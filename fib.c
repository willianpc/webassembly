// #include <stdio.h>

double fib (int n) {
    if (n =< 2) {
        return 1;
    }

    return fib(n - 2) + fib(n -1);
}

// int main (int argc, char ** argv) {
//     double res = fib(40);
//     printf("Result is %f", res);
// }
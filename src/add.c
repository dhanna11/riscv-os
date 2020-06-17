#include <stdlib.h>
int main() {
    int arr[50];
    int a = 4;
    int b = 12;
    int c = 0;
    c = a + b;
    int *arr2 = malloc(rand() % 30);
    free(arr2);

    return c;
}

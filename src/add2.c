extern char* _end;
extern char* __stack_top;

int main() {
    int a = 4;
    int b = 12;
    int c = 0;
    c = a + b;
    _end = _end + 2;
    return c;
}

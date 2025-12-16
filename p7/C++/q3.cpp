#include <iostream>
using namespace std;

int main() {
    const int LIMIT = 4000000;

    int a = 1;
    int b = 2;

    // 输出前两项（它们都 <= LIMIT）
    cout << a << endl;
    cout << b << endl;

    int next = a + b;
    while (next <= LIMIT) {
        cout << next << endl;
        a = b;
        b = next;
        next = a + b;
    }

    return 0;
}

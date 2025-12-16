#include <iostream>
#include <vector>
using namespace std;

void print_vector(const vector<int>& v) {
    cout << "[";
    for (size_t i = 0; i < v.size(); i++) {
        cout << v[i];
        if (i + 1 < v.size()) cout << ", ";
    }
    cout << "]" << endl;
}


int main() {
    vector<int> v = {1, 2, 3, 10};
    print_vector(v);
    return 0;
}

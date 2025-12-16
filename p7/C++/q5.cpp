#include <iostream>
#include <vector>
using namespace std;
void print_pascals(int n) {
    if (n <= 0) return;

    vector<long long> row;  // Preventing small n from overflowing too quickly
    row.push_back(1);

    for (int i = 0; i < n; i++) {
        // Print the current line
        for (size_t j = 0; j < row.size(); j++) {
            cout << row[j] << (j + 1 < row.size() ? " " : "");
        }
        cout << "\n";

        // next[j] = row[j-1] + row[j]
        vector<long long> next(row.size() + 1, 1);
        for (size_t j = 1; j < row.size(); j++) {
            next[j] = row[j - 1] + row[j];
        }
        row = next;
    }
}
int main() {
    int n;
    cout << "Enter n: ";
    cin >> n;
    print_pascals(n);
    return 0;
}

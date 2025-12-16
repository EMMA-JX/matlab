#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

// 你之前写过的打印函数（如果你已有版本也可以替换）
void print_vector(const vector<int>& v) {
    cout << "[";
    for (size_t i = 0; i < v.size(); i++) {
        cout << v[i];
        if (i + 1 < v.size()) cout << ", ";
    }
    cout << "]" << endl;
}

// 4.1 If Prime
bool isprime(int n) {
    if (n < 2) return false;
    if (n == 2) return true;
    if (n % 2 == 0) return false;

    for (int d = 3; d * d <= n; d += 2) {
        if (n % d == 0) return false;
    }
    return true;
}

// 4.2 Factorize (all factors / divisors)
vector<int> factorize(int n) {
    vector<int> answer;
    if (n == 0) {
        // 0 的因子在数学上不太定义清楚；作业一般不会测 0
        return answer;
    }
    if (n < 0) n = -n; // 如果给负数，按绝对值处理

    for (int d = 1; d * d <= n; d++) {
        if (n % d == 0) {
            answer.push_back(d);
            if (d != n / d) answer.push_back(n / d);
        }
    }
    sort(answer.begin(), answer.end());
    return answer;
}

// 4.3 Prime Factorization (prime factors with multiplicity)
vector<int> prime_factorize(int n) {
    vector<int> answer;
    if (n == 0) return answer;        // 一般不会测
    if (n < 0) n = -n;                // 按绝对值处理
    if (n < 2) return answer;         // 0,1 没有质因数

    while (n % 2 == 0) {
        answer.push_back(2);
        n /= 2;
    }
    for (int p = 3; p * p <= n; p += 2) {
        while (n % p == 0) {
            answer.push_back(p);
            n /= p;
        }
    }
    if (n > 1) answer.push_back(n);   // 剩下的 n 本身是质数
    return answer;
}

// Test cases from prompt
void test_isprime() {
    cout << "isprime(2) = " << isprime(2) << '\n';
    cout << "isprime(10) = " << isprime(10) << '\n';
    cout << "isprime(17) = " << isprime(17) << '\n';
}

void test_factorize() {
    print_vector(factorize(2));
    print_vector(factorize(72));
    print_vector(factorize(196));
}

void test_prime_factorize() {
    print_vector(prime_factorize(2));
    print_vector(prime_factorize(72));
    print_vector(prime_factorize(196));
}

int main() {
    test_isprime();
    test_factorize();
    test_prime_factorize();
    return 0;
}

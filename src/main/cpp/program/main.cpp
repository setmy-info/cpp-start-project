#include "main.h"
#include <cstdlib>
#include <iostream>

using namespace SetmyInfo;
using namespace std;

extern char** environ;

int main(const int argc, const char * const argv[]) {
	char** env = environ;
    cout << "Hello World!" << endl;
    while (*env != nullptr) {
           cout << *env << endl;
           env++;
    }
    return 0;
}

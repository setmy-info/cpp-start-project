#include "Application.h"

using namespace SetMyInfo;

int main(const int argc, const char *argv[]) {
    Application app;
    app.Args(argc, argv);
    return app.Main();
}

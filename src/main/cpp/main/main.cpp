#include "Application.h"

using namespace set_my_info;

int main(const int argc, const char *argv[]) {
    Application app;
    app.Args(argc, argv);
    return app.Main();
}

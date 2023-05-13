cmake_minimum_required (VERSION 3.26.3)

# PLACEHOLDER-BEGIN #

PROJECT (cpp-start-project)

SET (PROJECT_VERSION_MAJOR              0)
SET (PROJECT_VERSION_MINOR              0)
SET (PROJECT_VERSION_PATCH              0)
SET (PROJECT_VERSION_TWEAK              0)

SET (PROJECT_DESCRIPTION_SUMMARY        "setmy.info cpp start project")
SET (PROJECT_DESCRIPTION                "setmy.info cpp start project example")
SET (PROJECT_VENDOR                     "Hear And See Systems LLC")
SET (PROJECT_MAINTAINER                 "Imre Tabur <imre.tabur@mail.ee>")
SET (PROJECT_WWW                        "https://setmy.info")
SET (PROJECT_LICENSE                    "MIT")

INCLUDE(./resources/cmake/variables.txt)
INCLUDE(./resources/cmake/targets.txt)
INCLUDE(./resources/cmake/dependencies.txt)
INCLUDE(./resources/cmake/configure.txt)
INCLUDE(./resources/cmake/lib.txt)
INCLUDE(./resources/cmake/bin.txt)
INCLUDE(./resources/cmake/man.txt)
INCLUDE(./resources/cmake/etc.txt)

# PLACEHOLDER-PRE-PACKAGING #

INCLUDE(./resources/cmake/packaging.txt)

# PLACEHOLDER-END #

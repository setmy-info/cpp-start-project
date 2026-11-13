# PLACEHOLDER-BEGIN #
MESSAGE("-- main cpp sources.cmake")

INCLUDE_DIRECTORIES("/usr/include")
# Forward slashes: a Windows path is valid with them, and a backslash in a macro argument is an
# escape sequence or not depending on policy CMP0219.
INCLUDE_DIRECTORIES_WINDOWS("C:/pub/boost_1_82_0")

# PLACEHOLDER-END #

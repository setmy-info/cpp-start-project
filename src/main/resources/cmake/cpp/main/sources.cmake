# PLACEHOLDER-BEGIN #
MESSAGE("-- main sources.cmake")

# Hack for CMAKE strange architecture problems with variable scopes (No global scope)
SET (TEMP_MAIN_MODULE_PATH    "${MAIN_CPP_SOURCES_PATH}/main")
SET (MAIN_MODULE_PATH    "${TEMP_MAIN_MODULE_PATH}")
SET (MAIN_MODULE_SOURCES "${TEMP_MAIN_MODULE_PATH}/main.cpp")

INCLUDE_DIRECTORIES("${MAIN_MODULE_PATH}/include")

# PLACEHOLDER-END #

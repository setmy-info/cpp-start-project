# Copies the applications Mix built, cmake -DSOURCE=<build>/lib -DDESTINATION=<dir> -P, into
# DESTINATION, which is emptied first, so a module or a dependency that is gone is gone from the
# package too. Of every application: ebin, priv and the consolidated protocols, not the build
# manifests of .mix.

FILE(REMOVE_RECURSE "${DESTINATION}")
FILE(MAKE_DIRECTORY "${DESTINATION}")
FILE(GLOB APPLICATIONS LIST_DIRECTORIES true RELATIVE "${SOURCE}" "${SOURCE}/*")
FOREACH(APPLICATION IN LISTS APPLICATIONS)
    FOREACH(PART ebin priv consolidated)
        IF(IS_DIRECTORY "${SOURCE}/${APPLICATION}/${PART}")
            FILE(COPY "${SOURCE}/${APPLICATION}/${PART}" DESTINATION "${DESTINATION}/${APPLICATION}"
                FOLLOW_SYMLINK_CHAIN)
        ENDIF()
    ENDFOREACH()
    MESSAGE("Elixir application ${APPLICATION} in ${DESTINATION}")
ENDFOREACH()

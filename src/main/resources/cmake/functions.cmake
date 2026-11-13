# PLACEHOLDER-BEGIN #
MESSAGE("-- functions.cmake")

macro(INCLUDE_CMAKE_FILE)
    IF(EXISTS ${ARGV0})
        MESSAGE("INCLUDING: ${ARGV0}")
        INCLUDE(${ARGV0})
    ELSE()
        MESSAGE("NOT INCLUDING: ${ARGV0} - FILE DOESN'T EXIST")
    ENDIF()
endmacro()

macro(INCLUDE_DIRECTORIES_WINDOWS)
    IF (WIN32)
        INCLUDE_DIRECTORIES(${ARGV0})
    ENDIF()
endmacro()

# Project layout, the same under src/main/resources/cmake and src/test/resources/cmake:
#
#   <phase>.cmake                     project wide part of a phase
#   <language>/<phase>.cmake          language wide part, optional
#   <language>/<module>/<phase>.cmake module part, optional
#
# A phase is one of variables, sources, targets, dependencies, configure, lib, bin, man, etc, var.
# Languages and modules are found from the directories, so adding or removing a language or a
# module is adding or removing its directory and running ./configure again; no file lists them.
# A module or language without anything to do in a phase simply has no file for it.

# GET_SUBDIRECTORIES(<result> <directory>)
# The names of the directories directly under <directory>, "base" first when there is one, as it
# holds what the other modules build on, then the rest in alphabetical order.
function(GET_SUBDIRECTORIES RESULT DIRECTORY)
    SET(_SUBDIRECTORIES "")
    IF(IS_DIRECTORY "${DIRECTORY}")
        FILE(GLOB _CHILDREN LIST_DIRECTORIES true RELATIVE "${DIRECTORY}" "${DIRECTORY}/*")
        LIST(SORT _CHILDREN)
        FOREACH(_CHILD IN LISTS _CHILDREN)
            IF(IS_DIRECTORY "${DIRECTORY}/${_CHILD}")
                LIST(APPEND _SUBDIRECTORIES "${_CHILD}")
            ENDIF()
        ENDFOREACH()
        IF("base" IN_LIST _SUBDIRECTORIES)
            LIST(REMOVE_ITEM _SUBDIRECTORIES "base")
            LIST(PREPEND _SUBDIRECTORIES "base")
        ENDIF()
    ENDIF()
    SET(${RESULT} "${_SUBDIRECTORIES}" PARENT_SCOPE)
endfunction()

# INCLUDE_MODULES_CMAKE_FILES(<language directory> <phase>)
# Includes <language directory>/<module>/<phase>.cmake of every module that has it. It is called
# for a language automatically after its <language>/<phase>.cmake. A language file calls it itself
# only when it needs the modules earlier, for example to collect what they set; they are then not
# included a second time. These are macros and not functions, as the files they include set
# variables for the whole project.
macro(INCLUDE_MODULES_CMAKE_FILES SMI_MODULES_DIRECTORY SMI_MODULES_PHASE)
    GET_SUBDIRECTORIES(_SMI_MODULES "${SMI_MODULES_DIRECTORY}")
    FOREACH(_SMI_MODULE IN LISTS _SMI_MODULES)
        IF(EXISTS "${SMI_MODULES_DIRECTORY}/${_SMI_MODULE}/${SMI_MODULES_PHASE}.cmake")
            MESSAGE("INCLUDING: ${SMI_MODULES_DIRECTORY}/${_SMI_MODULE}/${SMI_MODULES_PHASE}.cmake")
            INCLUDE("${SMI_MODULES_DIRECTORY}/${_SMI_MODULE}/${SMI_MODULES_PHASE}.cmake")
        ENDIF()
    ENDFOREACH()
    SET(_SMI_MODULES_INCLUDED_${SMI_MODULES_PHASE} TRUE)
endmacro()

# INCLUDE_LANGUAGES_CMAKE_FILES(<cmake directory> <phase>)
# For every language directory under <cmake directory>: its <phase>.cmake, then its modules.
macro(INCLUDE_LANGUAGES_CMAKE_FILES SMI_LANGUAGES_DIRECTORY SMI_LANGUAGES_PHASE)
    GET_SUBDIRECTORIES(_SMI_LANGUAGES "${SMI_LANGUAGES_DIRECTORY}")
    FOREACH(_SMI_LANGUAGE IN LISTS _SMI_LANGUAGES)
        SET(_SMI_MODULES_INCLUDED_${SMI_LANGUAGES_PHASE} FALSE)
        IF(EXISTS "${SMI_LANGUAGES_DIRECTORY}/${_SMI_LANGUAGE}/${SMI_LANGUAGES_PHASE}.cmake")
            MESSAGE("INCLUDING: ${SMI_LANGUAGES_DIRECTORY}/${_SMI_LANGUAGE}/${SMI_LANGUAGES_PHASE}.cmake")
            INCLUDE("${SMI_LANGUAGES_DIRECTORY}/${_SMI_LANGUAGE}/${SMI_LANGUAGES_PHASE}.cmake")
        ENDIF()
        IF(NOT _SMI_MODULES_INCLUDED_${SMI_LANGUAGES_PHASE})
            INCLUDE_MODULES_CMAKE_FILES("${SMI_LANGUAGES_DIRECTORY}/${_SMI_LANGUAGE}" "${SMI_LANGUAGES_PHASE}")
        ENDIF()
    ENDFOREACH()
endmacro()

# ADD_COPY_TARGET(<target> <destination> <glob>...)
# A target that copies the files matching the globs into <destination>. With no matching file it
# does nothing, so a module whose sources are not written yet builds without an edit. The globs
# are checked again by every build, which reconfigures when a file has been added or removed.
function(ADD_COPY_TARGET TARGET_NAME DESTINATION)
    SET(_FILES "")
    IF(ARGN)
        FILE(GLOB _FILES LIST_DIRECTORIES false CONFIGURE_DEPENDS ${ARGN})
    ENDIF()
    LIST(FILTER _FILES EXCLUDE REGEX "/\\.empty$")
    IF(_FILES)
        ADD_CUSTOM_TARGET(${TARGET_NAME}
            COMMAND ${CMAKE_COMMAND} -E make_directory "${DESTINATION}"
            COMMAND ${CMAKE_COMMAND} -E copy ${_FILES} "${DESTINATION}"
            VERBATIM)
    ELSE()
        ADD_CUSTOM_TARGET(${TARGET_NAME})
    ENDIF()
endfunction()

# ADD_COPY_DIRECTORY_TARGET(<target> <destination> <source directory>)
# A target that copies the content of <source directory> with its subdirectories into
# <destination>, and does nothing when there is no such directory.
function(ADD_COPY_DIRECTORY_TARGET TARGET_NAME DESTINATION SOURCE_DIRECTORY)
    IF(IS_DIRECTORY "${SOURCE_DIRECTORY}")
        ADD_CUSTOM_TARGET(${TARGET_NAME}
            COMMAND ${CMAKE_COMMAND} -E copy_directory "${SOURCE_DIRECTORY}" "${DESTINATION}"
            VERBATIM)
    ELSE()
        ADD_CUSTOM_TARGET(${TARGET_NAME})
    ENDIF()
endfunction()

# ADD_MAN_TARGET(<target> <man source directory> <section>...)
# A target that copies the pages of the sections, <man source directory>/manN/*.N, into
# ${MAN_OUTPUT_PATH}/manN and compresses them, and does nothing when there is no page.
function(ADD_MAN_TARGET TARGET_NAME MAN_SOURCE_DIRECTORY)
    SET(_COMMANDS "")
    FOREACH(_SECTION IN LISTS ARGN)
        FILE(GLOB _PAGES LIST_DIRECTORIES false CONFIGURE_DEPENDS "${MAN_SOURCE_DIRECTORY}/man${_SECTION}/*.${_SECTION}")
        IF(_PAGES)
            SET(_COPIED "")
            FOREACH(_PAGE IN LISTS _PAGES)
                GET_FILENAME_COMPONENT(_PAGE_NAME "${_PAGE}" NAME)
                LIST(APPEND _COPIED "${MAN_OUTPUT_PATH}/man${_SECTION}/${_PAGE_NAME}")
            ENDFOREACH()
            LIST(APPEND _COMMANDS
                COMMAND ${CMAKE_COMMAND} -E make_directory "${MAN_OUTPUT_PATH}/man${_SECTION}"
                COMMAND ${CMAKE_COMMAND} -E copy ${_PAGES} "${MAN_OUTPUT_PATH}/man${_SECTION}"
                COMMAND gzip -f ${_COPIED})
        ENDIF()
    ENDFOREACH()
    ADD_CUSTOM_TARGET(${TARGET_NAME} ${_COMMANDS} VERBATIM)
endfunction()

# CONFIGURE_DIRECTORY(<source directory> <destination>)
# Configures every *.in file under <source directory>, its subdirectories included, into the same
# place under <destination> without the .in suffix. @ONLY, as a script or a systemd unit may hold
# a ${VARIABLE} of its own, which is not cmake's. Nothing happens when there is no such directory.
function(CONFIGURE_DIRECTORY SOURCE_DIRECTORY DESTINATION)
    IF(IS_DIRECTORY "${SOURCE_DIRECTORY}")
        FILE(GLOB_RECURSE _TEMPLATES LIST_DIRECTORIES false RELATIVE "${SOURCE_DIRECTORY}" "${SOURCE_DIRECTORY}/*.in")
        FOREACH(_TEMPLATE IN LISTS _TEMPLATES)
            STRING(REGEX REPLACE "\\.in$" "" _CONFIGURED "${_TEMPLATE}")
            CONFIGURE_FILE("${SOURCE_DIRECTORY}/${_TEMPLATE}" "${DESTINATION}/${_CONFIGURED}" @ONLY)
        ENDFOREACH()
    ENDIF()
endfunction()

# PLACEHOLDER-END #

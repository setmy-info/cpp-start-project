# PLACEHOLDER-BEGIN #
MESSAGE("-- site.cmake")

# Documentation in markdown, in the places maven gives it:
#
#   src/site/markdown/**/*.md    the pages
#   src/site/resources/...       images and other files the pages refer to
#
# make all copies both into doc/<project> of the package. make site builds the site under
# target/site: every page as HTML when pandoc is installed, the markdown as it is otherwise. The
# markdown is always copied beside the HTML, so a link between pages, written with the .md name
# as it has to be for the pages to work in a git web view, still finds its target.

SET (SITE_SOURCES_PATH      ${SOURCES_PATH}/site)
SET (SITE_OUTPUT_PATH       ${TARGET_PATH}/site)
SET (SITE_DOC_OUTPUT_PATH   ${DOC_OUTPUT_PATH}/${PROJECT_NAME})

ADD_COPY_DIRECTORY_TARGET(buildDocMarkdown  ${SITE_DOC_OUTPUT_PATH} ${SITE_SOURCES_PATH}/markdown)
ADD_COPY_DIRECTORY_TARGET(buildDocResources ${SITE_DOC_OUTPUT_PATH} ${SITE_SOURCES_PATH}/resources)
ADD_DEPENDENCIES(build buildDocMarkdown buildDocResources)
ADD_DEPENDENCIES(buildDocMarkdown  makeDirectories)
ADD_DEPENDENCIES(buildDocResources makeDirectories)

INSTALL(DIRECTORY "${DOC_OUTPUT_PATH}/" DESTINATION doc OPTIONAL)

FIND_PROGRAM(PANDOC_EXECUTABLE pandoc)
FILE(GLOB_RECURSE SITE_PAGES RELATIVE "${SITE_SOURCES_PATH}/markdown" CONFIGURE_DEPENDS "${SITE_SOURCES_PATH}/markdown/*.md")
SET (SITE_COMMANDS
    COMMAND ${CMAKE_COMMAND} -E rm -rf ${SITE_OUTPUT_PATH}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${SITE_OUTPUT_PATH})
IF(IS_DIRECTORY "${SITE_SOURCES_PATH}/resources")
    LIST(APPEND SITE_COMMANDS COMMAND ${CMAKE_COMMAND} -E copy_directory ${SITE_SOURCES_PATH}/resources ${SITE_OUTPUT_PATH})
ENDIF()
IF(IS_DIRECTORY "${SITE_SOURCES_PATH}/markdown")
    LIST(APPEND SITE_COMMANDS COMMAND ${CMAKE_COMMAND} -E copy_directory ${SITE_SOURCES_PATH}/markdown ${SITE_OUTPUT_PATH})
ENDIF()
IF(PANDOC_EXECUTABLE)
    FOREACH(SITE_PAGE IN LISTS SITE_PAGES)
        STRING(REGEX REPLACE "\\.md$" ".html" SITE_HTML "${SITE_PAGE}")
        LIST(APPEND SITE_COMMANDS COMMAND ${PANDOC_EXECUTABLE} --standalone --from gfm --to html5
            --metadata pagetitle=${PROJECT_NAME}
            --output ${SITE_OUTPUT_PATH}/${SITE_HTML} ${SITE_SOURCES_PATH}/markdown/${SITE_PAGE})
    ENDFOREACH()
ELSE()
    LIST(APPEND SITE_COMMANDS COMMAND ${CMAKE_COMMAND} -E echo "pandoc not found: the site is the markdown of ${SITE_OUTPUT_PATH}")
ENDIF()
ADD_CUSTOM_TARGET(buildSite ${SITE_COMMANDS} VERBATIM)
ADD_DEPENDENCIES(site buildSite)

MESSAGE("-- SITE_SOURCES_PATH: ${SITE_SOURCES_PATH}")
MESSAGE("-- SITE_OUTPUT_PATH: ${SITE_OUTPUT_PATH}")

# PLACEHOLDER-END #

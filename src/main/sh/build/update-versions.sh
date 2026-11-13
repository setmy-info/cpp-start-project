#!/bin/sh

# Sets the project version everywhere it is written: CMakeLists.txt, Doxyfile, Dockerfile,
# packages-build.sh and the spec file packages of src/main/rpm. Run from the project root:
#
#   ./src/main/sh/build/update-versions.sh 1.2.3

NEW_VERSION="${1:?Usage: update-versions.sh <new-version>  (e.g. 1.2.3)}"

if ! printf '%s' "${NEW_VERSION}" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo "Error: version has to be MAJOR.MINOR.PATCH, not ${NEW_VERSION}" >&2
    exit 1
fi
if [ ! -f CMakeLists.txt ]; then
    echo "Error: run from the project root, CMakeLists.txt not found" >&2
    exit 1
fi

MAJOR=$(printf '%s' "${NEW_VERSION}" | cut -d. -f1)
MINOR=$(printf '%s' "${NEW_VERSION}" | cut -d. -f2)
PATCH=$(printf '%s' "${NEW_VERSION}" | cut -d. -f3)
PROJECT_NAME=$(sed -n 's/^PROJECT *( *\([^ )]*\).*/\1/p' CMakeLists.txt)

# sed -i is not POSIX, so every file goes through a temporary copy.
replace() {
    FILE=$1
    EXPRESSION=$2
    if [ -f "${FILE}" ]; then
        sed "${EXPRESSION}" "${FILE}" > "${FILE}.tmp" && cat "${FILE}.tmp" > "${FILE}" && rm -f "${FILE}.tmp"
        echo "Updated ${FILE}"
    fi
}

replace CMakeLists.txt "s/\(SET (PROJECT_VERSION_MAJOR *\)[0-9]*/\1${MAJOR}/"
replace CMakeLists.txt "s/\(SET (PROJECT_VERSION_MINOR *\)[0-9]*/\1${MINOR}/"
replace CMakeLists.txt "s/\(SET (PROJECT_VERSION_PATCH *\)[0-9]*/\1${PATCH}/"
replace Doxyfile "s/^\(PROJECT_NUMBER *=\).*/\1 ${NEW_VERSION}/"
replace Dockerfile "s/${PROJECT_NAME}-[0-9][0-9.]*[0-9]\./${PROJECT_NAME}-${NEW_VERSION}./g"
replace src/main/sh/build/packages-build.sh "s/export PROJECT_VERSION=\"[0-9][0-9.]*\"/export PROJECT_VERSION=\"${NEW_VERSION}\"/"
replace README.md "s/PROJECT_VERSION=[0-9][0-9.]*[0-9]/PROJECT_VERSION=${NEW_VERSION}/g"

# Spec file packages: a spec that writes its Version as a number, rather than @RPM_VERSION@ or
# %{smi_version}, and the "smi-config-version <version>" line a configuration file carries so the
# installed file says which version it is. Templates are left alone, they take the version from
# the build.
for SPEC in src/main/rpm/*/*.spec; do
    replace "${SPEC}" "s/^\(Version: *\)[0-9][0-9.]*\$/\1${NEW_VERSION}/"
done
if [ -d src/main/rpm ]; then
    grep -rl 'smi-config-version [0-9]' src/main/rpm 2>/dev/null | while IFS= read -r CONFIG_FILE; do
        replace "${CONFIG_FILE}" "s/\(smi-config-version \)[0-9][0-9.]*/\1${NEW_VERSION}/g"
    done
fi

exit 0

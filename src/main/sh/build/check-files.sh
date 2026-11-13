#!/bin/sh

# Checks an installed package: the installation directory exists, bin and lib are not empty and
# no installed text file has CRLF line endings. Run after rpm -i or apt install, as the Dockerfile
# does. A derived project adds its own checks at the end.

CHECK_DIR="${1:-/opt/setmy.info}"
FAILED=0

echo "Checking installation in ${CHECK_DIR}"

if [ ! -d "${CHECK_DIR}" ]; then
    echo "Error: ${CHECK_DIR} does not exist"
    exit 1
fi

check_directory() {
    DIR=$1
    MIN_FILES=$2
    if [ ! -d "${DIR}" ]; then
        echo "Error: ${DIR} does not exist"
        return 1
    fi
    FILE_COUNT=$(find "${DIR}" -type f | wc -l)
    echo "Found ${FILE_COUNT} files in ${DIR}, at least ${MIN_FILES} expected"
    if [ "${FILE_COUNT}" -lt "${MIN_FILES}" ]; then
        echo "Error: ${DIR} contains fewer than ${MIN_FILES} files"
        return 1
    fi
    return 0
}

check_line_endings() {
    DIR=$1
    [ -d "${DIR}" ] || return 0
    # printf, as $'\r' is not POSIX. -I skips binary files, which may hold the byte anyway.
    CR=$(printf '\r')
    FILES_WITH_CRLF=$(find "${DIR}" -type f -exec grep -lI "${CR}" {} +)
    if [ -n "${FILES_WITH_CRLF}" ]; then
        echo "Error: files with CRLF line endings in ${DIR}:"
        echo "${FILES_WITH_CRLF}"
        return 1
    fi
    echo "No CRLF line endings in ${DIR}"
    return 0
}

check_directory "${CHECK_DIR}/bin" 1 || FAILED=1
check_directory "${CHECK_DIR}/lib" 1 || FAILED=1
check_line_endings "${CHECK_DIR}/bin" || FAILED=1
check_line_endings "${CHECK_DIR}/lib" || FAILED=1
check_line_endings "${CHECK_DIR}/etc" || FAILED=1

if [ ! -d /var/opt/setmy.info ]; then
    echo "Error: /var/opt/setmy.info does not exist"
    FAILED=1
fi

if [ "${FAILED}" -ne 0 ]; then
    echo "Installation check FAILED"
    exit 1
fi
echo "Installation check passed"
exit 0

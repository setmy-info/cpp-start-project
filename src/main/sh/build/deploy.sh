#!/bin/sh

# Deploys the packages of one deploy target with smi-deploy of setmy-info-scripts. Called by the
# upload-*, handover-* and deploy-* targets that deploy.cmake generates, which also documents the
# variables:
#
#   deploy.sh upload|handover|deploy <target> --hosts=<default> --var=<var directory> PACKAGE...
#
# The machines of <target> are SMI_DEPLOY_<TARGET>_HOSTS of the environment, or the default the
# project was configured with. SMI_DEPLOY_<TARGET>_USER, _PORT, _REMOTE_DIR and _INCOMING_DIR set
# what smi-deploy reads as SMI_DEPLOY_USER and the others, for this target only.
# SMI_DEPLOY_STAGE=draft hands over to the draft directory, <var directory>/incoming/draft.
#
# The packages go one at a time, in the order given, which is their dependency order: the
# deployment service starts installing when the first one arrives.

set -u

COMMAND_NAME="${0##*/}"
ACTION="${1:-}"
TARGET="${2:-}"

usage() {
    echo "Usage: ${COMMAND_NAME} upload|handover|deploy TARGET --hosts=HOSTS --var=DIR PACKAGE..." >&2
    exit 1
}

case "${ACTION}" in
    upload|handover|deploy)
        ;;
    *)
        usage
        ;;
esac
[ -n "${TARGET}" ] || usage
shift 2

DEFAULT_HOSTS=
VAR_DIR=/var/opt/setmy.info
while [ ${#} -gt 0 ]; do
    case "${1}" in
        --hosts=*)
            DEFAULT_HOSTS="${1#--hosts=}"
            ;;
        --var=*)
            VAR_DIR="${1#--var=}"
            ;;
        *)
            break
            ;;
    esac
    shift
done
[ ${#} -gt 0 ] || usage

# test -> TEST, live-fe -> LIVE_FE
NAME=$(printf '%s' "${TARGET}" | tr 'a-z-' 'A-Z_')

# The value of the variable whose name is given, empty when it is not set.
valueOf() {
    eval "printf '%s' \"\${${1}:-}\""
}

HOSTS=$(valueOf "SMI_DEPLOY_${NAME}_HOSTS")
[ -n "${HOSTS}" ] || HOSTS="${DEFAULT_HOSTS}"
if [ -z "${HOSTS}" ]; then
    echo "${COMMAND_NAME}: no machines for ${TARGET}: set SMI_DEPLOY_${NAME}_HOSTS in the CI job or on the command line" >&2
    exit 1
fi
export SMI_DEPLOY_HOSTS="${HOSTS}"

for SETTING in USER PORT REMOTE_DIR INCOMING_DIR; do
    VALUE=$(valueOf "SMI_DEPLOY_${NAME}_${SETTING}")
    if [ -n "${VALUE}" ]; then
        export "SMI_DEPLOY_${SETTING}=${VALUE}"
    fi
done

if [ "${SMI_DEPLOY_STAGE:-published}" = draft ] && [ -z "${SMI_DEPLOY_INCOMING_DIR:-}" ]; then
    export SMI_DEPLOY_INCOMING_DIR="${VAR_DIR}/incoming/draft"
fi

SMI_DEPLOY_COMMAND="${SMI_DEPLOY_COMMAND:-smi-deploy}"
if ! command -v "${SMI_DEPLOY_COMMAND}" >/dev/null 2>&1; then
    echo "${COMMAND_NAME}: ${SMI_DEPLOY_COMMAND} not found: install the setmy-info-scripts package" >&2
    exit 1
fi

echo "${ACTION} to ${TARGET} (${HOSTS})${SMI_DEPLOY_INCOMING_DIR:+, incoming ${SMI_DEPLOY_INCOMING_DIR}}"
RESULT=0
for PACKAGE in "$@"; do
    "${SMI_DEPLOY_COMMAND}" "${ACTION}" "${PACKAGE}" || RESULT=1
done

exit ${RESULT}

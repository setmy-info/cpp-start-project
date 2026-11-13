# PLACEHOLDER-BEGIN #
MESSAGE("-- base var.cmake")

# /var is not packaged: the rpm post.install.sh and the deb postinst create
# /var/opt/setmy.info (SMI_RUNTIME_VAR_PATH). It cannot be an install rule. A relative DESTINATION
# goes under the package prefix, which made the unused /opt/setmy.info/var/opt/setmy.info, and an
# absolute one is not redirected by the CPack staging install, which then writes into the real
# /var of the build machine.

# PLACEHOLDER-END #

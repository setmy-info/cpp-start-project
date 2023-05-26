#!/bin/sh

# Executed by installer at install step end.
echo "### Post-Install"
SMI_PROVIDER=setmy.info
#ln -f -s /opt/${SMI_PROVIDER}/etc/some.sh /etc/profile.d/some.sh

exit ${?}

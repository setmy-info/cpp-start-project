#!/bin/sh

# Executed by installer at install step end.
echo "### Post-Install"
useradd --system microservice
SMI_PROVIDER=setmy.info
#ln -f -s /opt/${SMI_PROVIDER}/etc/example.sh /etc/profile.d/example.sh
#ln -f -s /opt/${SMI_PROVIDER}/etc/systemd/system/example.service /etc/systemd/system/example.service
#ln -f -s /opt/${SMI_PROVIDER}/bin/smi-example-binary /opt/${SMI_PROVIDER}/bin/smi-test
#ln -f -s /opt/${SMI_PROVIDER}/bin/smi-example-binary /opt/${SMI_PROVIDER}/bin/smi-stealer

exit ${?}

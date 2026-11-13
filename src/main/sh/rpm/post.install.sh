#!/bin/sh

# Executed by installer at install step end.
echo "### Post-Install"

USER_NAME=microservice
if ! id "${USER_NAME}" >/dev/null 2>&1; then
    # useradd ${USER_NAME} --shell /sbin/nologin --no-create-home
    useradd --system ${USER_NAME}
fi

SMI_PROVIDER=setmy.info
#ln -f -s /opt/${SMI_PROVIDER}/etc/profile.d/example.sh /etc/profile.d/example.sh
if command -v systemctl >/dev/null 2>&1; then
    echo ln -f -s /opt/${SMI_PROVIDER}/etc/systemd/system/example.service /etc/systemd/system/example.service
    #systemctl daemon-reload || true
    #systemctl enable --now example.service || true
fi
#ln -f -s /opt/${SMI_PROVIDER}/bin/smi-example-binary /opt/${SMI_PROVIDER}/bin/smi-test
#ln -f -s /opt/${SMI_PROVIDER}/bin/smi-example-binary /opt/${SMI_PROVIDER}/bin/smi-stealer
# Not packaged, see src/main/resources/cmake/sh/base/var.cmake.
mkdir -p /var/opt/${SMI_PROVIDER}
if command -v restorecon >/dev/null 2>&1; then
    restorecon -R /var/opt/${SMI_PROVIDER} || true
fi

exit ${?}

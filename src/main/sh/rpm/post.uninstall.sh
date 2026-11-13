#!/bin/sh

# De-install script, executed at uninstall end.
echo "### Post-Uninstall"

# Only on a real removal. On an upgrade rpm runs this script of the OLD package after the %post
# of the new one, with $1 set to the number of instances that stay, so without this guard every
# upgrade deletes what the new package has just created: links, /etc/profile.d entries, systemd
# units. $1 is 0 only when the package is really going away.
if [ "${1:-0}" != 0 ]; then
    echo "Upgrade, keeping the installation of the new package"
    exit 0
fi

SMI_PROVIDER=setmy.info
#rm -f /etc/profile.d/some.sh
#rm -f /opt/${SMI_PROVIDER}/bin/smi-test
#if command -v systemctl >/dev/null 2>&1; then
#    systemctl disable --now example.service || true
#fi
#rm -f /etc/systemd/system/example.service
#if command -v systemctl >/dev/null 2>&1; then
#    systemctl daemon-reload || true
#fi

exit 0

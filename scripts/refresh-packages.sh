#!/bin/bash -e

HERE=$(dirname $0)
PACKAGES_SH=$HERE/packages.sh

if [ -f "$PACKAGES_SH" ]; then
  # Comment out the old commands.
  sed -ri 's/^([^#])/# \1/' $PACKAGES_SH
fi

echo -e "\n# $(date)" >$PACKAGES_SH
zegrep "apt(-get)? (install|remove)" /var/log/apt/history* | sed 's/.*Commandline: //' >>$PACKAGES_SH
snap list | awk -f $HERE/snap-install.awk >>$PACKAGES_SH

chmod +x $PACKAGES_SH


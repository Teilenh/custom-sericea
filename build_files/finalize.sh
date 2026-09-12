#!/usr/bin/bash
set -euo pipefail

dnf5 config-manager setopt keepcache=0
dnf5 clean all

rm -rf \
    /var/cache/dnf \
    /var/cache/libdnf5 \
    /var/log/dnf* \
    /var/log/hawkey.log \
    /tmp/*

mkdir -p /var/tmp
chmod 1777 /var/tmp

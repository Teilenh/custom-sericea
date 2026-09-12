#!/usr/bin/bash
set -euo pipefail

dnf5 config-manager setopt keepcache=0
dnf5 clean all

# DNF build state
rm -rf \
    /var/cache/dnf \
    /var/cache/libdnf5 \
    /var/lib/dnf/repos

# Logs générés uniquement pendant la construction
rm -f \
    /var/log/dnf* \
    /var/log/hawkey.log

# /run et /tmp doivent être vides dans une image bootc.
find /run -mindepth 1 -delete
find /tmp -mindepth 1 -delete

# /var/tmp doit exister mais ne doit pas contenir
# les fichiers temporaires du build.
mkdir -p /var/tmp
find /var/tmp -mindepth 1 -delete
chmod 1777 /var/tmp

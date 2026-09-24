#!/usr/bin/bash
set -euo pipefail

dnf5 config-manager setopt keepcache=0
dnf5 clean all

rm -rf \
    /run/dnf \
    /run/selinux-policy \
    /run/setrans* \
    /var/lib/dnf/repos \
    /var/lib/rpm-state*
    
rm -f \
    /var/log/dnf* \
    /var/log/hawkey.log

# Résidus réellement créés pendant le build.
rm -rf \
    /run/dnf \
    /run/selinux-policy
    
# /tmp est déjà monté en tmpfs durant ce RUN,
# mais garder ça ne pose pas problème.
find /tmp -mindepth 1 -delete

mkdir -p /var/tmp
find /var/tmp -mindepth 1 -delete
chmod 1777 /var/tmp

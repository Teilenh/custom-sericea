#!/bin/bash
set -euo pipefail

# Clean DNF cache
dnf5 clean all
dnf5 autoremove -y

# Clean temp files
rm -rf /tmp/* 2>/dev/null || true

# Clean /var but preserve what bootc needs
# /var/lib, /var/log, /var/cache/libdnf5, /var/cache/rpm-ostree are kept
find /var/cache/* -maxdepth 0 -type d \
  ! -name libdnf5 \
  ! -name rpm-ostree \
  -exec rm -rf {} + 2>/dev/null || true

mkdir -p /var/tmp
chmod 1777 /var/tmp

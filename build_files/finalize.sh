#!/bin/bash
set -euo pipefail

# Clean DNF cache
dnf5 config-manager setopt keepcache=0

dnf5 autoremove -y
dnf5 clean all

# Clean temp files
rm -rf /tmp/* || true
find /var/* -maxdepth 0 -type d \
  ! -name libdnf5 \
  ! -name rpm-ostree \
  -exec rm -rf {} + 2>/dev/null || true
mkdir -p /var/tmp
chmod -R 1777 /var/tmp

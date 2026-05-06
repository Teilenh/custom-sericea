#!/bin/bash
set -euo pipefail

systemctl enable podman.socket

for drv in qemu interface network nodedev nwfilter secret storage
do
  sudo systemctl unmask virt${drv}d.socket
  sudo systemctl enable --now virt${drv}d.socket
done

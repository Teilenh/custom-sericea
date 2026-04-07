#!/bin/bash
set -euo pipefail

systemctl enable falcond.service
systemctl enable podman.socket

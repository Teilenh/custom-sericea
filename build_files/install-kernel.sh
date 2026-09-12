#!/usr/bin/bash
set -euo pipefail

mapfile -t kernel_dirs < <(
    find /usr/lib/modules \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        -printf '%f\n' |
        grep 'cachyos' |
        sort -V
)

if (( ${#kernel_dirs[@]} != 1 )); then
    printf 'Expected exactly one CachyOS kernel, found %s:\n' \
        "${#kernel_dirs[@]}" >&2
    printf '  %s\n' "${kernel_dirs[@]}" >&2
    exit 1
fi

KVER=${kernel_dirs[0]}
KERNEL_DIR="/usr/lib/modules/$KVER"
VMLINUX="$KERNEL_DIR/vmlinuz"
INITRAMFS="$KERNEL_DIR/initramfs.img"

echo "Using kernel: $KVER"

# Fedora Atomic:
# /root -> /var/roothome
#
# dracut peut avoir besoin de résoudre /root pendant le build.
mkdir -p -m 0700 /var/roothome

# Vérifications avant dracut
test -s "$VMLINUX"

depmod -a "$KVER"

# Ne jamais conserver les artefacts /boot générés par le RPM CachyOS.
# bootc utilisera /usr/lib/modules/$KVER/{vmlinuz,initramfs.img}.
find /boot -mindepth 1 -delete

DRACUT_LOG="$(mktemp)"
trap 'rm -f "$DRACUT_LOG"' EXIT

set +e
DRACUT_NO_XATTR=1 dracut \
    --force \
    --no-hostonly \
    --reproducible \
    --zstd \
    --add ostree \
    --tmpdir=/var/tmp \
    --kver "$KVER" \
    "$INITRAMFS" \
    2>&1 | tee "$DRACUT_LOG"

dracut_rc=${PIPESTATUS[0]}
set -e

if (( dracut_rc != 0 )); then
    echo "dracut exited with $dracut_rc" >&2
    exit "$dracut_rc"
fi

# dracut/dracut-install peut malheureusement produire certaines erreurs
# tout en laissant un archive initramfs derrière lui.
if grep -Eq \
    'dracut-install: ERROR:|dracut\[E\]: FAILED:' \
    "$DRACUT_LOG"
then
    echo "Fatal dracut error detected" >&2
    exit 1
fi

chmod 0600 "$INITRAMFS"

test -s "$VMLINUX"
test -s "$INITRAMFS"

lsinitrd "$INITRAMFS" >/dev/null

# Un bootc container ne doit rien embarquer dans /boot.
if find /boot -mindepth 1 -print -quit | grep -q .; then
    echo "/boot is not empty" >&2
    find /boot -mindepth 1 -maxdepth 2 -print >&2
    exit 1
fi

echo "Kernel image:"
ls -lh "$VMLINUX"

echo "Initramfs image:"
ls -lh "$INITRAMFS"

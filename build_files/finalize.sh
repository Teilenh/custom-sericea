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

# /tmp est déjà monté en tmpfs durant ce RUN,
# mais garder ça ne pose pas problème.
find /tmp -mindepth 1 -delete

mkdir -p /var/tmp
find /var/tmp -mindepth 1 -delete
chmod 1777 /var/tmp

### Image metadata, generated inside the image during the build.
IMAGE_PRETTY_NAME=Custom-Sericea
IMAGE_BRANCH_NORMALIZED=${IMAGE_BRANCH:-main}
if [[ "$IMAGE_BRANCH_NORMALIZED" == main ]]; then
    IMAGE_BRANCH_NORMALIZED=stable
fi
IMAGE_NAME=${IMAGE_NAME:-custom-sericea}
IMAGE_VENDOR=${IMAGE_VENDOR:-teilenh}
IMAGE_REGISTRY=${IMAGE_REGISTRY:-ghcr.io/teilenh}
IMAGE_TAG=${IMAGE_TAG:-latest}
VERSION_TAG=${VERSION_TAG:-local}
VERSION_PRETTY="$IMAGE_TAG-$VERSION_TAG"
PROJECT_URL="https://github.com/$IMAGE_VENDOR/$IMAGE_NAME"
FEDORA_VERSION=$(rpm -E %fedora)

mkdir -p /usr/share/ublue-os
jq -n \
    --arg name "$IMAGE_NAME" \
    --arg vendor "$IMAGE_VENDOR" \
    --arg ref "ostree-unverified-registry:$IMAGE_REGISTRY/$IMAGE_NAME:$IMAGE_TAG" \
    --arg tag "$IMAGE_TAG" \
    --arg branch "$IMAGE_BRANCH_NORMALIZED" \
    --arg fedora "$FEDORA_VERSION" \
    --arg version "$VERSION_TAG" \
    --arg pretty "$VERSION_PRETTY" \
    '{"image-name": $name, "image-vendor": $vendor, "image-ref": $ref,
      "image-tag": $tag, "image-branch": $branch,
      "base-image-name": "fedora-sway-atomic", "fedora-version": $fedora,
      "version": $version, "version-pretty": $pretty}' \
    > /usr/share/ublue-os/image-info.json

# Keep Fedora's ID, CPE and IMAGE_ID: these identify the distribution and kernel
# integration, rather than the custom image's presentation.
set_os_release() {
    local key=$1 value=$2
    value=${value//\\/\\\\}
    value=${value//\"/\\\"}
    value=${value//\$/\\\$}
    value=${value//\`/\\\`}
    sed -i "/^${key}=/d" /usr/lib/os-release
    printf '%s="%s"\n' "$key" "$value" >> /usr/lib/os-release
}

set_os_release NAME "$IMAGE_PRETTY_NAME"
set_os_release PRETTY_NAME "$IMAGE_PRETTY_NAME (Fedora $FEDORA_VERSION)"
set_os_release VARIANT_ID "$IMAGE_NAME"
set_os_release DEFAULT_HOSTNAME custom-sericea
set_os_release DOCUMENTATION_URL "$PROJECT_URL/blob/$IMAGE_BRANCH/README.md"
set_os_release SUPPORT_URL "$PROJECT_URL/issues"
set_os_release BUG_REPORT_URL "$PROJECT_URL/issues"
set_os_release BUILD_ID "$VERSION_PRETTY"
set_os_release BOOTLOADER_NAME "$IMAGE_PRETTY_NAME $VERSION_PRETTY"

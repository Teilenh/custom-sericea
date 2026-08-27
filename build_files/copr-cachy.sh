## script for copr of cachy

dnf5 install linux-firmware amd-ucode
# Add CachyOS COPR repository
dnf5 copr enable bieszczaders/kernel-cachyos
dnf5 copr enable bieszczaders/kernel-cachyos-addons

# Install CachyOS kernel
dnf5 install kernel-cachyos kernel-cachyos-devel
# enable the above policy to load kernel modules.
sudo setsebool -P domain_kernel_load_modules on

#!/bin/bash
set -euo pipefail

# Add Flathub remote if not present
flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install apps
flatpak install --system --noninteractive flathub \
  md.obsidian.Obsidian \
  com.ranfdev.DistroShelf \
  io.github.kolunmi.Bazaar

#!/usr/bin/env bash
set -u

# Commands parsed by the script must have a predictable locale.
export LC_ALL=C

# ── Colors ────────────────────────────────────────────────────────────────

if [[ -t 1 ]]; then
    BOLD=$'\033[1m'
    DIM=$'\033[2m'
    RED=$'\033[31m'
    GREEN=$'\033[32m'
    YELLOW=$'\033[33m'
    CYAN=$'\033[36m'
    RESET=$'\033[0m'
else
    BOLD="" DIM="" RED="" GREEN="" YELLOW="" CYAN="" RESET=""
fi

ok()   { printf "${GREEN}●${RESET} %s\n" "$*"; }
warn() { printf "${YELLOW}●${RESET} %s\n" "$*"; }
fail() { printf "${RED}●${RESET} %s\n" "$*"; }

section() {
    printf "\n${BOLD}${CYAN}╭─ %s${RESET}\n" "$1"
}

item() {
    printf "${DIM}│${RESET}  ${BOLD}%-18s${RESET} %s\n" "$1" "$2"
}

end_section() {
    printf "${DIM}╰──────────────────────────────────────────────────────────────────────${RESET}\n"
}

# ── Header ────────────────────────────────────────────────────────────────

printf "\n${BOLD}SERICEA HEALTH${RESET}\n"
printf "${DIM}─────────────────────────────────────────────────────────────────────────${RESET}\n"


# ── IMAGE ─────────────────────────────────────────────────────────────────

section "IMAGE"

BOOTED_IMAGE="$(
    rpm-ostree status 2>/dev/null |
    awk '
        /●/ {
            line=$0
            sub(/^.*ostree-/, "ostree-", line)
            print line
            exit
        }
    '
)"

# Strip rpm-ostree transport prefix for readability.
BOOTED_IMAGE="${BOOTED_IMAGE#ostree-unverified-registry:}"
BOOTED_IMAGE="${BOOTED_IMAGE#ostree-image-signed:}"
BOOTED_IMAGE="${BOOTED_IMAGE#ostree-unverified-image:}"

item "Booted image" "${BOOTED_IMAGE:-unknown}"

end_section


# ── MEMORY ────────────────────────────────────────────────────────────────

section "MEMORY"

RAM="$(
    free -h |
    awk '/^Mem:/ { print $3 " / " $2 }'
)"

item "RAM" "$RAM"

if zramctl --noheadings 2>/dev/null | grep -q .; then
    ZRAM_SIZE="$(
        zramctl --noheadings --output DISKSIZE 2>/dev/null |
        head -1 |
        xargs
    )"

    item "ZRAM" "${ZRAM_SIZE:-unknown}"
else
    fail "ZRAM inactive"
fi

end_section


# ── STORAGE ───────────────────────────────────────────────────────────────

FS_USED="$(df -Ph /var | awk 'NR==2 { print $5 }')"
FS_FREE="$(df -Ph /var | awk 'NR==2 { print $4 }')"

HOME_SIZE="$(du -sh "$HOME" 2>/dev/null | awk '{print $1}')"
VAR_SIZE="$(du -sh --exclude=home /var 2>/dev/null | awk '{print $1}')"

printf "\n${BOLD}${CYAN}╭─ STORAGE - %s used • %s free${RESET}\n" "$FS_USED" "$FS_FREE"

item "/home" "${HOME_SIZE:-unknown} used"
item "/var"  "${VAR_SIZE:-unknown} used"

end_section
# ── SYSTEMD ───────────────────────────────────────────────────────────────

section "SYSTEMD"

FAILED_OUTPUT="$(
    systemctl --failed --no-legend --plain 2>/dev/null || true
)"

FAILED_COUNT="$(
    printf '%s\n' "$FAILED_OUTPUT" |
    sed '/^[[:space:]]*$/d' |
    wc -l
)"

if (( FAILED_COUNT == 0 )); then
    ok "No failed units"
else
    fail "$FAILED_COUNT failed unit(s)"

    printf '%s\n' "$FAILED_OUTPUT" |
    awk '
        NF {
            printf "│  %-28s %s\n", $1, substr($0, index($0,$5))
        }
    '
fi

end_section


# ── FLATPAK ──────────────────────────────────────────────────────────────

section "FLATPAK"

if command -v flatpak >/dev/null 2>&1; then
    APPS="$(
        flatpak list --app --columns=application 2>/dev/null |
        sed '/^[[:space:]]*$/d' |
        wc -l
    )"

    RUNTIMES="$(
        flatpak list --runtime --columns=application 2>/dev/null |
        sed '/^[[:space:]]*$/d' |
        wc -l
    )"

    item "Applications" "$APPS"
    item "Runtimes" "$RUNTIMES"
else
    item "Flatpak" "not installed"
fi

end_section


# ── PODMAN ────────────────────────────────────────────────────────────────

section "PODMAN"

if command -v podman >/dev/null 2>&1; then
    PODMAN_DF="$(podman system df 2>/dev/null || true)"

    if [[ -n "$PODMAN_DF" ]]; then
        printf '%s\n' "$PODMAN_DF" |
        sed 's/^/│  /'
    else
        warn "Unable to read Podman storage"
    fi
else
    item "Podman" "not installed"
fi

end_section

printf "\n"

#!/usr/bin/env bash

# ==============================
# CONFIG
# ==============================
DIR="/usr/share/rofi/menu"
RASI="powermenu.rasi"
CNFR="confirm.rasi"

# ==============================
# THEME
# ==============================

get_flag() {
    grep -E "^$2" "$1" 2>/dev/null | cut -d'=' -f2 | tr -d ' '
}

USE_ICON=$(get_flag "$RASI" "USE_ICON")
CNF_ICON=$(get_flag "$CNFR" "USE_ICON")

prompt="$(hostname) ($(whoami))"
mesg="Uptime : $(uptime -p)"

# Options
if [[ "$USE_ICON" == "NO" ]]; then
    lock=" Lock"
    logout="󰍃 Logout"
    suspend=" Suspend"
    reboot=" Reboot"
    shutdown=" Shutdown"
else
    lock=""
    logout="󰍃"
    suspend=""
    reboot=""
    shutdown=""
fi

if [[ "$CNF_ICON" == "NO" ]]; then
    yes=" Yes"
    no=" No"
else
    yes=""
    no=""
fi

# ==============================
# ROFI
# ==============================

rofi_cmd() {
    rofi -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme "$RASI"
}

confirm_cmd() {
    rofi -dmenu \
        -p "Confirmation" \
        -mesg "Are you sure?" \
        -theme "$CNFR"
}

confirm_run() {
    choice=$(printf "%s\n%s" "$yes" "$no" | confirm_cmd)
    [[ "$choice" == "$yes" ]] && "$@"
}

# ==============================
# ACTIONS (Sway + Fedora)
# ==============================

do_lock() {
    swaylock
}

do_logout() {
    swaymsg exit
}

do_suspend() {
    confirm_run sh -c "
        mpc -q pause 2>/dev/null
        pamixer --mute 2>/dev/null
        swaylock
        systemctl suspend
    "
}

do_reboot() {
    confirm_run systemctl reboot
}

do_shutdown() {
    confirm_run systemctl poweroff
}

# ==============================
# MENU
# ==============================

chosen=$(printf "%s\n%s\n%s\n%s\n%s" \
    "$lock" "$logout" "$suspend" "$reboot" "$shutdown" | rofi_cmd)

case "$chosen" in
    "$lock") do_lock ;;
    "$logout") confirm_run do_logout ;;
    "$suspend") do_suspend ;;
    "$reboot") do_reboot ;;
    "$shutdown") do_shutdown ;;
esac

#!/bin/sh
# Обработчик ACPI-событий яркости для acpid (THUNDEROBOT 911S — Fn+F8/F9
# шлют только ACPI-события video/brightnessdown|up, key-событий нет).
# Правило: /etc/acpi/events/brightness -> вызывает этот скрипт с %e в $1.
# $1 = подсистема события, $2 = действие (BRTDN/BRTUP), $3/$4 = коды.

case "$1" in
    video/brightnessdown) brightnessctl --quiet set 2%- ;;
    video/brightnessup)   brightnessctl --quiet set +2% ;;
esac

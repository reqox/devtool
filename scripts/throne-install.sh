wget https://github.com/throneproj/Throne/releases/download/1.3.2/Throne-1.3.2-debian-amd64.deb && 
sudo apt install ./Throne-1.3.2-debian-amd64.deb &&
sudo apt install \
  libopengl0 \
  libxcb-cursor0 \
  pkexec \
  lxqt-policykit \
  waybar &&
rm ./Throne-1.3.2-debian-amd64.deb

# --- зачем каждый пакет -----------------------------------------------

# libopengl0  -> libOpenGL.so.0
#   Обязательно. libQt6Gui из /opt/Throne/usr/lib линкуется на libOpenGL.so.0,
#   пакет throne тянет только desktop-file-utils, поэтому библиотеки нет.
#   Без неё бинарник вообще не запускается (падает до создания окна).
#
# libxcb-cursor0 -> libxcb-cursor.so.0
#   Нужен Qt-плагину xcb (/opt/Throne/usr/plugins/platforms/libqxcb.so).
#   На Wayland основной плагин wayland, но xcb пригодится для XWayland-окна
#   и как запасной вариант. Типичная ошибка без него:
#   "Could not load the Qt platform plugin xcb".
#
# pkexec -> /usr/bin/pkexec
#   TUN-режим: root получает только ядро ThroneCore, пароль спрашивается через pkexec.
#   (Пакет policykit-1 в 26.04 больше нет, pkexec живёт в одноимённом пакете pkexec.)
#   Запускать саму программу через sudo НЕЛЬЗЯ.
#
# lxqt-policykit -> polkit-агент
#   В Sway нет встроенного поликит-агента, поэтому диалог с запросом пароля
#   от pkexec не появится и TUN-режим зависнет. Агент стартует из автозапуска:
#   exec --no-startup-id lxqt-policykit
#   Альтернатива: policykit-1-gnome (есть в universe) или polkit-kde-agent-1.
#
# waybar -> трей с иконкой Throne
#   swaybar не умеет показывать иконки в трее, а для прокси-утилиты трей
#   обязателен (быстрый доступ, индикация состояния). В waybar нужен модуль tray:
#   "tray": { "icon-size": 20, "show-passive-items": true }
#   Альтернатива: waybar есть и в Sway-конфиге как основная панель.

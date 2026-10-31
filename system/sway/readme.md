```bash
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then exec sway; fi
```

```bash
ln -s ~/.devtool/system/sway/sway-config ~/.config/sway/config
```


/root/.xinitrc
```sh
#!/bin/bash
export DISPLAY=:0
matchbox-window-manager &
exec chromium --no-sandbox --app=http://www.runeaudio.com --start-fullscreen
```

```sh
pacman -S chromium

xinit &
```

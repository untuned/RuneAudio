## RuneAudio install
```sh
pacman -S chromium nss
sed -i -e '/^midori/ {
s/^/#/
a\
chromium --no-sandbox --app=http://localhost --start-fullscreen
' /root/.xinitrc

# run
xinit &> /dev/null &
```

## ArchLinuxArm - install
```sh
pacman -S chromium

echo '#!/bin/bash
export DISPLAY=:0
matchbox-window-manager &
chromium --no-sandbox --app=http://www.runeaudio.com --start-fullscreen
' > /root/.xinitrc

# run
xinit &> /dev/null &
```

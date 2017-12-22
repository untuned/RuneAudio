### RuneAudio install after MPD upgrade
```sh
pacman -S chromium libwebp nss

sed -i -e '/export DISPLAY/ a\
# fix: Failed to launch GPU process
export BROWSER=chromium
' -e '/^midori/ {
s/^/#/
a\
chromium --no-sandbox --app=http://localhost --start-fullscreen
' /root/.xinitrc

# run
xinit &> /dev/null &
```

### ArchLinuxArm - install
```sh
pacman -S xorg-server xorg-xinit chromium

echo '#!/bin/bash
export DISPLAY=:0
matchbox-window-manager &
chromium --no-sandbox --app=http://www.runeaudio.com --start-fullscreen
' > /root/.xinitrc

# run
xinit &> /dev/null &
```

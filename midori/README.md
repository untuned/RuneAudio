## Midori Upgrade

Upgrade from default Midori to latest version without errors:
- `pacman -S midori` upgrade alone breaks Midori
- Fix dependency errors

**issue: `webkitWebProcess` - very high cpu load**
- manual refresh brings it back to normal


## Run Midori without matchbox-window-manager

`/.config/midori/config`
```sh
...
# must match local screen
last-window-width=1920
last-window-height=1080
...
```

`/.xinitrc`
```sh
#!/bin/bash

exec midori -e Fullscreen
```

**restart**
```sh
killall Xorg
xinit &> /dev/null &
```
(manual refresh may needed)

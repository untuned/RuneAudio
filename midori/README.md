## Midori Upgrade
Midori is not required if display output on RPi is not needed.  
`Menu` > `Settings` > `Disable local browser` : saves around 6% CPU load and 45MB memory.  

Upgrade from default Midori to latest version without errors:
- **RuneUI Enhancement** should be installed to fix too high CPU load
- `pacman -S midori` upgrade alone breaks Midori
- Fix dependency errors

## Run Midori without matchbox-window-manager
`/.config/midori/config`
```sh
...
# must match local screen
last-window-width=1920
last-window-height=1080
...
```
(stylesheet and extension should be removed)

`/.xinitrc`
```sh
#!/bin/bash

exec midori -e Fullscreen
```

**restart**
```sh
# stop x
killall Xorg

# clear cache
rm /root/.config/midori/history.db-shm

# start x and midori
xinit &> /dev/null &
```
(manual refresh may needed)

**note**
- `/root/.config/midori` will be created by `xinit midori`
- then create `.xinitrc`

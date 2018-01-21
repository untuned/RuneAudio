Kernel Update
---

- Expand partition
```sh
#!/bin/bash

alias=kern

. /srv/http/addonstitle.sh

version=$( uname -r | cut -d'-' -f1 )

if [[ $version > 4.4.39 ]]; then
	title "$info Kernel already upgraged to $version"
	exit
fi

title -l '=' "$bar Upgrade Kernel ..."
timestart

rankmirrors

/srv/http/git pull
/srv/http/git checkout 0.4b

pacman -Sy --force --noconfirm raspberrypi-firmware raspberrypi-bootloader linux-raspberrypi linux-firmware cifs-utils

# get kernel version
version=$( pacman -Q linux-raspberrypi | cut -d' ' -f2 )

redis-cli set kernel "Linux runeaudio ${version}-ARCH" &> /dev/null

timestop
title -l '=' "$bar Kernel upgraded successfully."

echo -e "$info Please wait until reboot finished ..."

reboot
```

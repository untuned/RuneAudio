Kernel Update
---

- Expand partition
```sh
cd /srv/http/
git pull
git checkout 0.4b

pacman -Sy --force --noconfirm raspberrypi-firmware raspberrypi-bootloader linux-raspberrypi linux-firmware cifs-utils

# get kernel version
version=$( pacman -Q linux-raspberrypi | cut -d' ' -f2 )

redis-cli set kernel "Linux runeaudio ${version}-ARCH"

reboot
```

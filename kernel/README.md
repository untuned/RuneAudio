Kernel Update
---

- Expand partition
```sh
cd /srv/http/
git pull
git checkout 0.4b

pacman -Sy --force --noconfirm raspberrypi-firmware raspberrypi-bootloader linux-raspberrypi linux-firmware

# get kernel version
version=$( pacman -Q linux-raspberrypi )

redis-cli set kernel $version
```

with normal ArchLinuxArm build environment already setup
```sh
pacman -Sy libconfig xmltoman

useradd shairport-sync

su alarm
cd
mkdir shairport-sync
wget https://github.com/rern/RuneAudio/raw/master/shairport-sync/_repo/PKGBUILD
wget https://github.com/rern/RuneAudio/raw/master/shairport-sync/_repo/shairport-sync.sysusers

makepkg
```

Midori Upgrade
---

Problem with `webkitWebProcess` - very high cpu usage!
```sh
bacman midori-rune
pacman -R midori-rune
pacman -S --noconfirm gstreamer gstreamer-vaapi glib2 gtk3 harfbuzz freetype2 libsoup libgcrypt gpg-crypter libgpg-error libwebp enchant icu

ln -s /lib/libicuuc.so.{60.1,56}
ln -s /lib/libicudata.so.{60.1,56}

pacman -S midori
```

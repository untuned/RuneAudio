### shairport-sync

Compiled from [shairport-sync](https://github.com/mikebrady/shairport-sync) with `---with-metadata` for metadata retrieval.

**Install**
```sh
wget https://github.com/rern/RuneAudio/raw/master/shairport-sync/shairport-sync-3.2.1-1-armv7h.pkg.tar.xz
wget https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wget https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
pacman -Sy libconfig
pacman -U shairport-sync-3.2.1-1-armv7h.pkg.tar.xz
```

**Configure**
```sh
# set usable volume range
sed -i '/name = "%H"/ i\
    volume_range_db = 50;
' /etc/shairport-sync.conf

# set usb dac
sed -i '/output_device = "default"/ i\
    output_device = "hw:1";\
    output_format = "S32";
' /etc/shairport-sync.conf

### set onboard dac (3.5mm jack)
sed -i '/output_device = "default"/ i\
    output_device = "hw:0";\
    mixer_control_name = "PCM";
' /etc/shairport-sync.conf
# activate improved audio driver
if ! grep 'audio_pwm_mode=2' /boot/config.txt; then
    sed -i '$ a\audio_pwm_mode=2' /boot/config.txt
fi
###

# set metadata pipe
sed -i '/enabled = "no"/ i\
    enabled = "yes";\
    include_cover_art = "yes";\
    pipe_name = "/tmp/shairport-sync-metadata";\
    pipe_timeout = 5000;
' /etc/shairport-sync.conf

# run in background
sed '/^ExecStart/ s/$/ -d/' /usr/lib/systemd/system/shairport-sync.service
```

**Usage**
```sh
# start
systemctl start shairport-sync

# metadata pipe
shairport-sync-metadata-reader < /tmp/shairport-sync-metadata
```

**Switch to current output_device**
```sh
ao=$( redis-cli get ao )
card=$( aplay -l | grep "$ao" | sed 's/card \(.\):.*/\1/' )
if [[ $card == 0 ]]; then
    string=$( cat <<'EOF
    output_device = "hw:0";
    mixer_control_name = "PCM";
EOF
)
else
    string=$( cat <<'EOF
    output_device = "hw:1";
    output_format = "S32";
EOF
)
fi
sed -i '/output_device = "default"/ i$string' /etc/shairport-sync.conf
systemctl restart shairport-sync
```

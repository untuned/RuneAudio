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

# test dac's capable output_format  -f [ U8, S8, S16, S24, S24_3LE, S24_3BE, S32 ]
cat /dev/urandom | timeout 1 aplay -f S16
# support format stdout without this error line:
#    aplay: pcm_write:1940: write error: Interrupted system call

# ## set usb dac
sed -i '/output_device = "default"/ i\
    output_device = "hw:1";\
    output_format = "S32";
' /etc/shairport-sync.conf

# ## set onboard dac (3.5mm jack)
sed -i '/output_device = "default"/ i\
    output_device = "hw:0";\
    mixer_control_name = "PCM";
' /etc/shairport-sync.conf
# activate improved audio driver
if ! grep 'audio_pwm_mode=2' /boot/config.txt; then
    sed -i '$ a\audio_pwm_mode=2' /boot/config.txt
fi
# ##

# set metadata pipe
sed -i '/enabled = "no"/ i\
    enabled = "yes";\
    include_cover_art = "yes";\
    pipe_name = "/tmp/shairport-sync-metadata";\
    pipe_timeout = 5000;
' /etc/shairport-sync.conf

# run in background
sed '/^ExecStart/ s/$/ -d/' /usr/lib/systemd/system/shairport-sync.service
systemctl daemon-reload
```

**Usage**
```sh
# start
systemctl start shairport-sync

# shairport-sync-metadata-reader
shairport-sync-metadata-reader < /tmp/shairport-sync-metadata

# standard cat metadata
# ...
# <item><type>636f7265</type><code>6173616c</code><length>18</length>
# <data encoding="base64">
# U29uZ3Mgb2YgSW5ub2NlbmNl</data></item>
# ...
# code:
# hex        string  type
# 61736172 = asar => artist
# 6d696e6d = minm => title
# 6173616c = asal => album
# 70726772 = prgr => start/elapsed/end
# 50494354 = PICT => cover
#

cat /tmp/shairport-sync-metadata\
	| grep -A 2 '61736172\|6d696e6d\|6173616c\|70726772\|50494354'\
	| grep -v '<data encoding="base64">\|--'\
	| sed 's/61736172/artist:/; s/6d696e6d/title:/; s/6173616c/album:/; s/70726772/time:/; s/50494354/cover:/'\
	| sed 's|<item><type>.*</type><code>||; s|</code><length>.*</length>||; s|</data></item>||; s|</item>||'\
	| perl -p -e 's/:\n/: "/'\
	| perl -p -e 's/\n/",\n/'\
	| sed '/7063656e/ d'

# ...
# album: "U29uZ3Mgb2YgSW5ub2NlbmNl",
# ...
# data:
# js base64 to string: atob( 'U29uZ3Mgb2YgSW5ub2NlbmNl' ); // 'Songs of Innocence'
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

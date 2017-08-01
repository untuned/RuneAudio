**rdb file**  
`/var/lib/redis/rune.rdb`

**redis-cli**
```
### Sources ###
#redis-cli set usb_db_autorebuild 0    # usb auto rebuild

### MPD ###
#redis-cli set ao bcm2835 ALSA_1       # audio output (string*)
#redis-cli set volume 0                # volume control
#redis-cli set mpd_start_volume -1     # start volume
#redis-cli set dynVolumeKnob 0         # volume knob

### Settings ###
#redis-cli set hostname runeaudio      # hostname (string)
#redis-cli set ntpserever pool.ntp.org # ntpserever (string)
#redis-cli set timezone Europe/Berlin  # timezone (string from list)
#redis-cli set orionprofile RuneAudio  # sound signature (string from list)
#redis-cli hset airplay enable 0       # airplay
#hset spotify enable 0                 # spotify
#redis-cli hset dlna enable 0          # upnp/dlna
#redis-cli set local_browser 0         # local browser
#redis-cli set udevil 0                # usb automount
#redis-cli set coverart 0              # album cover
#redis-cli hset lastfm enable 0        # upnp/dlna

### Development ###
#redis-cli set opcache 0               # opcache
#redis-cli set dev 1                   # dev mode
#redis-cli set debug 0                 # debug
```

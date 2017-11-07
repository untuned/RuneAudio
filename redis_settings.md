**rdb file**  
`/var/lib/redis/rune.rdb`

**by pages**
```sh
### Sources ###
redis-cli set usb_db_autorebuild 0    # usb auto rebuild

### MPD ###
redis-cli set ao bcm2835 ALSA_1       # audio output (string*)
redis-cli set volume 0                # volume control
redis-cli set mpd_start_volume -1     # start volume
redis-cli set dynVolumeKnob 0         # volume knob
redis-cli hset mpdconf <hash> <value> # general music daemon options
                                      # crossfade - mpc crossfade 0
redis-cli set globalrandom 0          # global random
redis-cli set addrandom 1             # add random tracks

### Settings ###
redis-cli set hostname runeaudio      # hostname (string)
redis-cli set ntpserever pool.ntp.org # ntpserever (string)
redis-cli set timezone Europe/Berlin  # timezone (string from list)
redis-cli set orionprofile RuneAudio  # sound signature (string from list)
redis-cli hset airplay enable 0       # airplay
redis-cli hset spotify enable 0       # spotify
redis-cli hset dlna enable 0          # upnp/dlna
redis-cli set local_browser 0         # local browser
redis-cli set udevil 0                # usb automount
redis-cli set coverart 0              # album cover
redis-cli hset lastfm enable 0        # upnp/dlna

### Development ###
redis-cli set opcache 0               # opcache
redis-cli set dev 1                   # dev mode
redis-cli set debug 0                 # debug
```

**all keys**  
```sh
acards
acards_details
act_player_info
activePlayer
addrandom
airplay
ao
bcm2835 ALSA
bookmarksidx
buildversion
cmediafix
coverart
debug
debugdata
dev
dirble
dlna
dynVolumeKnob
eth0
eth0_hash
git
globalrandom
hostname
hwplatform
hwplatformid
i2smodule
jamendo
kernel
lastfm
lastfm_apikey
lastsongid
local_browser
lock_globalrandom
lock_refresh_ao
lock_wifiscan
mountidx
mpd_playback_laststate
mpd_playback_status
mpd_start_volume
mpdconf
mpdconf_advanced
mpdconfhash
netconf_advanced
netconfhash
nextsongid
nics
ntpserver
opcache
orionprofile
php_opcache_prime
PHPREDIS_SESSION:j0f01assphq0hl7dfk9o7s9im4
pl_length
playerid
playmod
proxy
ramplay
release
resolvconf
snd_rpi_wsp
spotify
stoppedPlayer
stored_profiles
timezone
udevil
usb_db_autorebuild
usbmounts
volume
webradios
wlan_autoconnect
wlan0_hash
wlans
```

**delete network mount**  
`Menu` > `Sources` > select mount
- get the last `<number>` in URL
- get mount `<name>`
```sh
redis-cli del mount_<number>
rm /mnt/MPD/NAS/<name>
```

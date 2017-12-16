MPD Upgrade
---
_Tested on RuneAudio 0.3 and 0.4b_

Upgrade MPD to latest version, 0.19.17/0.19.19 to 0.20.12 as of 20171126. (changelog: [www.musicpd.org](www.musicpd.org))
- RuneAudio installed customized MPD 0.19 which cannot be upgraded normally
- RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu`
- Fix issues in normal upgrade:
	- fix missing libs
		- libcrypto.so.1.0
		- libssl.so.1.0
	- remove package conflicts
		- mpd-rune
		- ffmpeg-rune
		- ashuffle-rune
	- install missing packages
		- gcc-libs
		- ffmpeg
		- icu
		- libnfs
		- libwebp
		- wavpack
	- fix systemd unknown lvalue
	- fix mpd.log permission
	- fix broken Midori
		- fix missing libs
			- libicui18n.so.56
			- libicuuc.so.56
			- libwebp.so.6
			- libicudata.so.56
		- installed missing packages
			- glib2
			- gtk3
			- webkitgtk

**Upgrade**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)

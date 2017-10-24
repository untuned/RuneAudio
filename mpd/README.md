MPD Upgrade
---
  
- RuneAudio installed customized MPD 0.19.13 which cannot be upgrade normally
- RuneAudio has trouble with system wide upgrade. **Do not** `pacman -Syu`
- This addon upgrade MPD to latest version fixes errors caused by normal upgrade:
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
	- fix mpg.log permission
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

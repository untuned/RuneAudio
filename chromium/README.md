Chromium Browser
---

- Default local browser is customized Midori, `midori-rune`, which cannot be upgraded
- MPD upgrade breaks **Midori** and upgrade has high CPU load issue
- **Firefox** has trouble with depends
- **Chromium** can be used instead with the least issues
	- Chromium cannot be installed without `ffmpeg` upgrade
	- `ffmpeg` upgrade breaks `mpd-rune`
	- upgrade `ffmpeg` + `mpd` > install `chromium`
	- fix ipv6 probing
	- fix scaling

Chromium Browser
---

- Default local browser is customized Midori, `midori-rune`, which cannot be upgraded
- MPD upgrade breaks Midori and cannot be fixed
- **Chromium** can be used instead
	- Chromium cannot be installed without `ffmpeg` upgrade
	- `ffmpeg` upgrade breaks `mpd-rune`
	- upgrade `ffmpeg` + `mpd` > install `chromium`
	- fix ipv6 probing
	- fix scaling
	- need `hdmi_group` and `hdmi_mode` [setting](https://www.raspberrypi.org/documentation/configuration/config-txt/video.md)

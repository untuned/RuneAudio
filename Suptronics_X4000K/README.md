Suptronics X4000K
---

### Hardware
- 1st layer spacers: short ones with threaded tips
- fixed base spacers:
  - threads are very tight 
  - beware head cut off
  - should fix only front-left and rear-right

### Software
- HDMI on X4000 cannot auto switch to a proper mode - no output on local screen
- SSH to RPi
- Append `hdmi_group=n` and `hdmi_mode=n` to `config.txt`
- reboot

- Settings: Menu > MPD
	- Audio output interface = RaspberryPi HDMI Out
	- Volume control = enabled - hardware / disabled

### Playback  
**via HDMI**
- DSD64
	- fine
	- CPU load ±50% (on single core)
- DSD128
	- a lot of drop out
	- CPU load ±90% (on single core)
	

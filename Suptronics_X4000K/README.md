Suptronics X4000K
---

### Hardware
- 1st layer spacers: short ones with threaded tips
- fixed base spacers:
  - threads are very tight 
  - beware head cut off
  - should fix only front-left and rear-right

### Software  
**HDMI**
- HDMI on X4000 cannot auto switch to a proper mode - no output on local screen
- Append `hdmi_group=n` and `hdmi_mode=n` to `config.txt`
- Initial power on there will be no output until reboot  
**Audio**
- Menu > Settings
	- I²S kernel modules = RPI DAC (via HDMI, DSD128 stutters)
		- `Apply Settings`
- Menu > MPD
	- Audio output interface = I-Sabre DAC (I²S)
	- Volume control = disabled
- Support up to DSD128 (DSD256 stutters)

DAC I2S ES9018K2M Board
---

![board](https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/ES9018K2M.jpg)
- Dirt cheap ES9018K2M on ebay
- Support DSD64 DSD128
- input: I2S
```
#1 DATA  <  RPi #40 (BCM #21)
#2 BCK   <  RPi #12 (BCM #18)
#3 LRCK  <  RPi #35 (BCM #19)
#4 -
#5 GND   <  RPi #39
```
![input](https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/input.png)
![gpio](https://github.com/rern/_assets/raw/master/RuneUI_GPIO/RPi3_GPIOs.png)
- Output:
	- RCA
	- 3.5mm headphone
- Power supply:
	- DC 9-5V
	- AC 7-0-7 to 18-0-18

### Reconfigure I2S data
```sh
#!/bin/bash

sed 's/"HiFiBerry DAC (I&#178;S)"/"HiFiBerry DAC (I&#178;S)","card_option":"format\t\"*:24:*\""/' /srv/http/db/redis_acards_details
redis-cli del acards
php /srv/http/db/redis_acards_details
```

### Setup
- Menu > Settings > I²S kernel modules = HiFiBerry Dac > `Apply Settings`
- reboot

- Menu > MPD > 
	- (optional) Volume control = Disabled for best quality
	- DSD support = DSD (native)
	- `Save and Apply`
	

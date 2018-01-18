DAC I2S ES9018K2M Board
---
_Tested on RPi3 RuneAudio 0.4b_

![board](https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/ES9018K2M.jpg)
- <10$ dirt cheap on ebay
- Support DSD64 DSD128
- `audio_output_format` must be set to `"*:24:*"`
	- `samplerate:bits:channels` 
	- no bit perfect on resampling
	- can be set to `"*:32:*"`
- Output:
	- RCA
	- 3.5mm headphone
- Power supply:
	- DC 9-5V
	- AC 7-0-7 to 18-0-18
- Input: I2S  
![input](https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/input.png)  
```
#1  <  RPi #40 (BCM #21)  -  DATA  data
#2  <  RPi #12 (BCM #18)  -  BCK   bit clock
#3  <  RPi #35 (BCM #19)  -  LRCK  left-right clock
#4 -
#5  <  RPi #39            -  GND   ground
```
![gpio](https://github.com/rern/_assets/raw/master/RuneUI_GPIO/RPi3_GPIOs.png)

### Reconfigure I2S data
```sh
sed 's/"HiFiBerry DAC (I&#178;S)"/"HiFiBerry DAC (I&#178;S)","card_option":"format\t\"*:24:*\""/' /srv/http/db/redis_acards_details
redis-cli del acards
php /srv/http/db/redis_acards_details
```

### Setup
- Menu > Settings
	- I²S kernel modules = HiFiBerry Dac
	- `Apply Settings`
- reboot

- Menu > MPD
	- (optional - if not use headphone) Volume control = Disabled (better quality)
	- DSD support = DSD (native)
	- `Save and Apply`
	

I²S ES9018K2M DAC Board
---
_Tested on RPi3 RuneAudio 0.3 and 0.4b_

![board](https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/ES9018K2M.jpg)
- [~10$ on ebay](https://www.ebay.com/sch/i.html?_from=R40&_sacat=0&_sop=15&_nkw=es9018k2m+board&rt=nc&LH_BIN=1)
- Support DSD64 DSD128
- Output: RCA and 3.5mm headphone
- Power supply: DC 9-25V via 5.5x2.1mm jack (or AC 7V-0-7V to 18V-0-18V - center tapped transformer via green terminal)
- Input: I²S  
![input](https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/input.png)  
```
#1  <  RPi #40 (BCM #21)  -  DATA  data
#2  <  RPi #12 (BCM #18)  -  BCK   bit clock
#3  <  RPi #35 (BCM #19)  -  LRCK  left-right clock
#4  -
#5  <  RPi #39            -  GND   ground
```
![gpio](https://github.com/rern/_assets/raw/master/RuneUI_GPIO/RPi3_GPIOs.png)

### Setup
**Hardware**
- Connect I²S wires
- Connect power supply

![jumper](https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/jumpers.jpg) ![adapter](https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/adapter.jpg)

**Software**  
for 0.3  
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/DAC_I2S_ES9018K2M/rpi-dac.dtbo -P /boot

sed -i '/"HiFiBerry DAC (I&#178;S)"/ i\
$redis->hSet(\x27acards_details\x27, \x27snd_rpi_rpi_dac\x27, \x27{"sysname":"snd_rpi_rpi_dac","extlabel":"I-Sabre DAC (I&#178;S)","hwplatformid":"08","type":"i2s"}\x27);
' /srv/http/db/redis_acards_details
redis-cli del acards
php /srv/http/db/redis_acards_details
###

sed -i '$ a\
dtoverlay=rpi-dac
' /boot/config.txt

/var/www/command/rune_shutdown
reboot
```

for 0.4b
- Menu > Settings
	- I²S kernel modules = `RPI DAC`
		- `Apply Settings`
		
- Reboot

for 0.3 and 0.4b
- Menu > MPD
	- Audio output interface = `I-Sabre DAC (I²S)`
	- (optional - if not use headphone) Volume control = `Disabled` (better quality)
	- (no need - for USB only) DSD support = `DSD (native)`
		- `Save and Apply`		

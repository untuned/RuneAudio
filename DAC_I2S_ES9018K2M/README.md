DAC I2S ES9018K2M Board
---
- Dirt cheap ES9018K2M
- Support DSD64 DSD128

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
	

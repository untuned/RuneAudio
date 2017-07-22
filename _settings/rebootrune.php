<?php
exec('/usr/bin/sudo /bin/echo 8 > /sys/module/bcm2709/parameters/reboot_part');
exec('/usr/bin/sudo /root/gpiooff.py; /usr/bin/sudo /root/reboot.py');

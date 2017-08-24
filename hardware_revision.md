**Hardware revision**  
```sh
cat /proc/cpuinfo | grep Revision | awk '{print $3}'
# a02082 - RPi 3 (Sony, UK)
# a22082 - RPi 3 (Embest, China)
# a01041 - RPi 2 (Sony, UK)
# a21041 - RPi 2 (Embest, China)
```

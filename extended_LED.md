**pwr_led**: #6`gnd` #8`v+`
```sh
sed -i '$ a\
enable_uart=1
' /boot/config.txt
```

**act_led**: #14`gnd` #18`v+`
```sh
sed -i '$ a\
dtparam=act_led_gpio=24
dtparam=act_led_trigger=default-on
' /boot/config.txt
```
![gpio](https://github.com/rern/_assets/raw/master/RuneUI_GPIO/RPi3_GPIOs.png)

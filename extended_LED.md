pwr_led: #6`gnd` #8`v+`
```sh
echo '
enable_uart=1
' /boot/config.txt
```

act_led: #14`gnd` #12`v+`
```sh
echo '
dtparam=act_led_gpio=18
dtparam=act_led_trigger=default-on
' /boot/config.txt
```

USB DAC Unmute
---

Fix mute USB DAC  

**ALSA configuration**  
```sh
alsamixer
```
![1](https://github.com/rern/RuneAudio/blob/master/USB_DAC_unmute/1.png)  

**Select Sound Device**  
`F6` select menu  
![2](https://github.com/rern/RuneAudio/blob/master/USB_DAC_unmute/2.png)  

**Setting**  
`MM` = mute  
![3](https://github.com/rern/RuneAudio/blob/master/USB_DAC_unmute/3.png)  

**Unmute**
- `M` toggles `MM` mute <-> `00` unmute  
- `left arrow` `right arrow` switches channel  
- `Esc` exit  

![4](https://github.com/rern/RuneAudio/blob/master/USB_DAC_unmute/4.png)  

**Save Setting**  
```sh
alsactl store
```

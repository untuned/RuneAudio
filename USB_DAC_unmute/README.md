USB DAC Unmute
---

Fix mute USB DAC  

**ALSA configuration**  
```sh
alsamixer
```
![1](https://github.com/rern/Assets/blob/master/alsamixer/1.png)  

**Select Sound Device**  
`F6`  
![2](https://github.com/rern/Assets/blob/master/alsamixer/2.png)  

**Setting**  
`MM` = mute  
![3](https://github.com/rern/Assets/blob/master/alsamixer/3.png)  

**Unmute**
- `M` toggles `MM` mute -> `00` unmute  
- `left arrow` `right arrow` switches channel  
- `Esc` exit  

![4](https://github.com/rern/Assets/blob/master/alsamixer/4.png)  

**Save Setting**  
```sh
alsactl store
```

Expand Partition
---

_Tested on RuneAudio RPi3_  

- **RuneAudio** install to 2GB partition by default.  
- This left the rest of the SD card not available for use.  
- **expand.sh** will expand the partiton to full capacity **without reboot**.  


**SSH command**

```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/expand_partition/expand.sh; chmod +x expand.sh; ./expand.sh
```

- Rank mirror servers with [**rankmirrors.sh**](https://github.com/rern/ArchLinuxArm_rankmirrors/)
- Install package **Parted**  
- Expand default 2GB partition to full capacity of SD card with **fdisk**  
- Probe new partition with **partprobe** (by **Parted**)  
- Resize to new partition with **resize2fs**  
- Done  

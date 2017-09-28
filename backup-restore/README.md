Backup-Restore update
---

**Issues**  
- RuneAudio 'Backup' works but should save database before backup
- Restore with 'Upload' was disabled for pending code

**Fixes**  
- Backup:
    - add `redis-cli save`
    - include `/mnt/MPD/Webradio`
    - exclude unnecessary `/etc/netctl/examples`
    - delete previous temporary file
- Restore:
    - remove default form event to avoid page change
    - upload file by ajax instead
    - use new php script to upload file
- Write permission:
    - http user cannot write outside `./http` or `sudo` bash commands directly
    - allow no password sudo in `/etc/sudoers.d`
    - use external bash script to restore
    
**Install**  
from [**Addons Menu**](https://github.com/rern/RuneAudio_Addons)  

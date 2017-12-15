NGINX Upgrade with pushstream
---

Upgrade from default **NGINX** 1.4.7 to 1.13.7 without errors:
- `pacman -S nginx` upgrades NGINX alone will break RuneUI
- RuneAudio needs NGINx with **pushstream**
- **pushstream** is not available as a separated package
- preserve `nginx.conf`
- restart seamlessly without dropping client connections

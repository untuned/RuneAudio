System upgrade complications
---

**Some `files exist` error:**
```sh
.../etc/ssl/certs/ca-certificates.crt exists in filesystem
.../usr/lib/firmware/brcm/brcmfmac43430-sdio.bin exists in filesystem
```sh

**Fix:**
```sh
pacman -Syuw                                      # download only
rm /etc/ssl/certs/ca-certificates.crt             # remove
rm /usr/lib/firmware/brcm/brcmfmac43430-sdio.bin  # remove
pacman -Su                                        # upgrade
```

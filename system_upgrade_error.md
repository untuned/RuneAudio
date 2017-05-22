System upgrade complications
---

**Some `files exist` error:**  
```sh
error: failed to commit transaction (conflicting files)
ca-certificates-utils: /etc/ssl/certs/ca-certificates.crt exists in filesystem
linux-firmware: /usr/lib/firmware/brcm/brcmfmac43430-sdio.bin exists in filesystem
Errors occurred, no packages were upgraded.
```

**Fix:**  
```sh
pacman -Syuw                                      # download only
rm /etc/ssl/certs/ca-certificates.crt             # remove
rm /usr/lib/firmware/brcm/brcmfmac43430-sdio.bin  # remove
pacman -Su                                        # upgrade
```

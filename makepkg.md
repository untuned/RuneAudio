Compile a package
---

```sh
useradd x
su x
mkdir -p /home/x
cd
cp /path/{PKGBUILD sourcefiles} /home/x/package
cd /home/user/package
makepkg -A --skippgpcheck
```

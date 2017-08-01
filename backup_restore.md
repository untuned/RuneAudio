Backup / Restore - settings + library
---

**Backup**
```sh
# settings - redis
redis-cli save
cp /var/lib/redis/rune.rdb /backup/path  

# library - mpd
cp /var/lib/mpd/mpd.db /backup/path 
```

**Restore**
```sh
# settings - redis
systemctl stop redis
mv /var/lib/redis/rune.rdb{,.backup}
cp /backup/path/rune.rdb /var/lib/redis
systemctl start redis

# library - mpd
systemctl stop mpd
mv /var/lib/mpd/mpd.db{,.backup}
cp /backup/path/mpd.db /var/lib/mpd
systemctl start mpd
```

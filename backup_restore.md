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
file=/var/lib/redis/rune.rdb
mv $file{,.original}
cp /backup/path/rune.rdb /var/lib/redis/
chown redis:redis $file
chmod 644 $file
systemctl restart redis

# library - mpd
file=/var/lib/mpd/mpd.db
mv $file{,.original}
cp /backup/path/mpd.db /var/lib/mpd
chown mpd:audio $file
chmod 644 $file
systemctl restart mpd
```

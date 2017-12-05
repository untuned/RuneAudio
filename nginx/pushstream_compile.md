```sh
# for pacman cache if available
rm -rf /var/cache/pacman
ln -sf /mnt/MPD/USB/hdd/varcache/pacman /var/cache/pacman

# rankmirrors
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/rankmirrors/rankmirrors.sh -P /usr/local/bin; chmod +x /usr/local/bin/rankmirrors.sh; rankmirrors.sh

pacman -S base-devel pcre zlib guile

useradd -m x
su x
cd

git clone https://github.com/wandenberg/nginx-push-stream-module.git

wget http://nginx.org/download/nginx-1.9.9.tar.gz
bsdtar xzvf nginx-1.9.9.tar.gz
cd nginx-1.9.9

./configure --sbin-path=/usr/local/sbin --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --user=nginx --group=nginx --with-http_gzip_static_module --with-cc-opt="-Wno-error" --add-module=../nginx-push-stream-module 

make

make install

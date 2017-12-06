

```sh
wget https://github.com/rern/RuneAudio/raw/master/nginx/nginx-1.13.7-2-any.pkg.tar.xz

pacman -U nginx-1.13.7-2-any.pkg.tar.xz

pacman -Sy php base-devel
wget https://github.com/phpredis/phpredis/archive/develop.zip
bsdtar xvf develop.zip
cd develop
phpize
./configure
make
make install

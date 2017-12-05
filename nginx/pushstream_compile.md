```sh
pacman -Sy
pacman -S base-devel pcre zlib guile murmur
useradd -m x
su x
cd

git clone https://github.com/wandenberg/nginx-push-stream-module.git
NGINX_PUSH_STREAM_MODULE_PATH=$PWD/nginx-push-stream-module

wget http://nginx.org/download/nginx-1.9.9.tar.gz
bsdtar xzvf nginx-1.9.9.tar.gz
cd nginx-1.9.9
./configure --add-module=../nginx-push-stream-module --with-cc-opt="-Wno-error"
make

make install

#!/bin/bash
set -e

nginx="nginx-1.26.2"
nginx_url="https://nginx.org/download/${nginx}.tar.gz"

ngx_connect_version="0.0.7"
ngx_connect="ngx_http_proxy_connect_module-$ngx_connect_version"
ngx_connect_url="https://github.com/chobits/ngx_http_proxy_connect_module/archive/refs/tags/v${ngx_connect_version}.tar.gz"

openssl="openssl-3.3.1"
openssl_url="https://github.com/openssl/openssl/releases/download/${openssl}/${openssl}.tar.gz"

pcre="pcre2-10.44"
pcre_url="https://github.com/PCRE2Project/pcre2/releases/download/${pcre}/${pcre}.tar.gz"

zlib="zlib-1.3.1"
zlib_url="http://zlib.net/${zlib}.tar.gz"


curl -Lo ${ngx_connect}.tar.gz $ngx_connect_url
curl -LO $nginx_url
curl -LO $openssl_url
curl -LO $pcre_url
curl -LO $zlib_url

tar -xf ${nginx}.tar.gz
tar -xf ${ngx_connect}.tar.gz
tar -xf ${openssl}.tar.gz
tar -xf ${pcre}.tar.gz
tar -xf ${zlib}.tar.gz


cd $nginx
patch -p1 < ../${ngx_connect}/patch/proxy_connect_rewrite_102101.patch

./configure \
	--prefix="." \
	--sbin-path="nginx" \
	--with-threads \
	--with-file-aio \
	--with-http_ssl_module \
	--with-http_v2_module \
	--with-stream \
	--with-stream_ssl_module \
	--with-stream_ssl_preread_module \
	--add-module="../$ngx_connect" \
	--with-ld-opt="-static -Wl,--as-needed -Wl,-Map,linker.map" \
	--with-pcre="../$pcre" \
	--with-zlib="../$zlib" \
	--with-openssl="../$openssl" \
	--with-debug \
	--http-client-body-temp-path="temp/client_body_temp" \
	--http-proxy-temp-path="temp/proxy_temp" \
	--without-http_fastcgi_module \
	--without-http_uwsgi_module \
	--without-http_scgi_module


make -j $(nproc)

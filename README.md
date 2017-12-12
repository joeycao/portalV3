cd /usr/local/openresty/lualib
ln -s /root/git/portalV3/src/portal portal
ln -s /root/git/portalV3/test test

/opt/app/openresty/nginx/conf
ln -s /root/git/portalV3/conf/nginx.conf nginx.conf 


cd /opt/app/openresty/bin

#https://github.com/membphis/lua-resty-test
#cp iresty_test.lua  /usr/local/openresty/lualib/resty

cd /opt/app/openresty/luajit/bin
./luarocks install lua-resty-template
./luarocks install luarestyredis
./luarocks install luafilesystem
./luarocks install lua-resty-cookie

 




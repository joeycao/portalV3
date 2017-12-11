cd /usr/local/openresty/lualib
ln -s /root/git/portalV3/src/portal portal
ln -s /root/git/portalV3/tests tests

cd /usr/local/openresty/nginx/conf
ln -s /root/git/portalV3/conf/nginx.conf nginx.conf 

#https://github.com/membphis/lua-resty-test
cp iresty_test.lua  /usr/local/openresty/lualib/resty

cd /usr/local/openresty/luajit/bin
./luarocks install lua-resty-template
./luarocks install luarestyredis
./luarocks install luafilesystem
./luarocks install lua-resty-cookie

 




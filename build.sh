#!/bin/bash
### environment check.
###
### something like:
### which git
### which npm
### ...
### here we just skip
src_dest =  https://github.com/loki951753/todolistOnline.git

#my git cant work in aliyun now
#git clone https://github.com/loki951753/todolistOnline.git build

#record the commands for develop bash script
#what should do:
#1.npm to download modules
#2.gulp to build
#3.after build, copy the file to correct floder, especially the sync floder
#4.return

cp -r /home/ftp/build/ .

cd build
npm install

gulp

cp release/js/app.js .

mkdir ./lib
cp release/server/js/todoFSApi.js release/server/js/util.js ./lib/

mkdir ./public
cp -r release/client/ ./public/static
cp src/client/index.html public/

#拷贝至七牛空间
cp -r ./public/static /sync





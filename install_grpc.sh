#!/bin/bash



protoc_file="protoc-3.10.0-rc-1-linux-x86_64.zip"
if [[ ! -e $protoc_file ]];then
wget https://github.com/protocolbuffers/protobuf/releases/download/v3.10.0-rc1/$protoc_file
test $? -ne 0 && "download failed for protoc" && exit
fi

protoc_dir=${protoc_file%.*}
mkdir -p $protoc_dir
unzip -o $protoc_file -d $protoc_dir
test $? -ne 0 && "unzip failed for protoc.zip" && exit


cp -fp $protoc_dir/bin/protoc /usr/local/bin/
test $? -ne 0 && echo "failed to copy protoc to /usr/local/bin" && exit

go get -u github.com/golang/protobuf/protoc-gen-go
test $? -ne 0 && echo "failed to install protoc-gen" && exit

rm -f $protoc_file
mv -f $protoc_dir /tmp/

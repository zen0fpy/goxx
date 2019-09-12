#/bin/bash


yum install -y  curl-devel expat-devel gettext-devel openssl-devel zlib-devel asciidoc gcc perl-ExtUtils-MakeMaker 

iconv="libiconv-1.14.tar.gz"
wget -c http://ftp.gnu.org/pub/gnu/libiconv/$iconv 
if [[ $? -ne 0 ]];then
 echo "fail to download icon" && exit
fi

iconv_dir=`echo $iconv|sed 's/.tar.gz//g'`
tar -zxvf $iconv
test $? -ne 0 && echo "fail to unzip $iconv" && exit

cd $iconv_dir
./configure --prefix=/usr/local/libiconv

make 
if [[ $? -eq 2 ]];then
 echo "fix $iconv_dir/srclib/stdio.in.h"
 sed -i  '698i\#if defined(__GLIBC__) && !defined(__UCLIBC__) && !__GLIBC_PREREQ(2, 16)' srclib/stdio.in.h 
 sed -i  '699a\#endif' srclib/stdio.in.h 
 make
fi


make install && yum remove git -y
test $? -ne 0 && echo "make iconv" && exit

cd ..

gitf="git-2.2.1.tar.gz"
wget -c https://mirrors.edge.kernel.org/pub/software/scm/git/$gitf
if [[ $? -ne 0 ]];then
  echo "fail to download git" && exit 
fi

git_dir=`echo $gitf|sed 's/.tar.gz//g'`

if [[ ! -e $git_dir ]];then
  tar -zxvf $gitf
  test $? -ne 0 && echo "fail to unzip $gitf" && exit
fi

cd $git_dir
make configure
./configure --prefix=/usr/local/git --with-iconv=/usr/local/libiconv

make &&  make install 
test $? -ne 0 && echo "make git failed" && exit

grep '/usr/local/git/bin' /etc/bashrc

if [[ $? -ne 0 ]];then
   echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
fi
cd ..

rm -rf $iconv_dir
rm -f $iconv
rm -f $gitf
rm -rf $git_dir

source /etc/bashrc

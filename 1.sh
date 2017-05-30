#!/bin/sh
#sudo suでrootになって実行する
#centをインストール後、Python3,Apache,djangoの導入と連携まで
#AWSで動かすならセキュリティグループでHTTPを開けとくこと

#アップデートと開発者用パッケージのインストール
yum update
yum -y groupinstall "Development Tools"
yum -y install gcc zlib-devel bzip2 bzip2-devel readline readline-devel sqlite sqlite-devel openssl openssl-devel

#pyenvでpythonをインストール
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile

echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

CONFIGURE_OPTS="--enable-shared" CFLAGS="-fPIC"; /root/.pyenv/bin/pyenv install 3.6.1
/root/.pyenv/bin/pyenv rehash
/root/.pyenv/bin/pyenv global 3.6.1
exec $SHELL -l

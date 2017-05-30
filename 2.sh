#!/bin/sh

pip install django

echo "<<<<<<<<<<<<<<<<<<<< python & django install success!! >>>>>>>>>>>>>>>>>>" > /root/setting.log

#django projectの作成
(cd /var/www/cgi-bin/; django-admin.py startproject test_proj)

#Apacheのインストール
yum -y install httpd httpd-devel

#wsgiのインストールと設定
yum -y install wget
wget https://github.com/GrahamDumpleton/mod_wsgi/archive/4.5.14.tar.gz
tar -zxvf 4.5.14.tar.gz

RHOME="/root"
$RHOME/mod_wsgi-4.5.14/configure CFLAGS=-fPIC --enable-shared --with-python=/root/.pyenv/versions/3.6.1/bin/python
(cd $RHOME/mod_wsgi-4.5.14; make) 
(cd $RHOME/mod_wsgi-4.5.14; make install)
ln -sf /root/.pyenv/versions/3.6.1/lib/libpython3.6m.so.1.0 /lib64/


echo "<<<<<<<<<<<<<<<<<<<< Apache & wsgi setting success!! >>>>>>>>>>>>>>>>>>" >> /root/setting.log

#pythonの設定の読み込み
cat << EOF > /etc/httpd/conf.d/python.conf

#1giの読み込み
LoadModule wsgi_module modules/mod_wsgi.so

# /test というリクエストに対して、/var/www/cgi-bin/hello.py 返す。
#WSGIScriptAlias /test /var/www/cgi-bin/hello.py

WSGIScriptAlias / /var/www/cgi-bin/test_proj/test_proj/wsgi.py
WSGIPythonHome /usr/local/pyenv/versions/3.6.1/
WSGIPythonPath /var/www/cgi-bin/test_proj

<Directory /var/www/cgi-bin/test_proj/test_proj>
<Files wsgi.py>
Require all granted
</Files>
</Directory>

EOF
#python.confの設定ここまで

#wsgi.pyの設定
cat << EOF > /var/www/cgi-bin/test_proj/test_proj/wsgi.py

"""
WSGI config for test_proj project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/1.11/howto/deployment/wsgi/
"""

import os
import site
import sys

sys.path.append('/var/www/cgi-bin/test_proj')
sys.path.append('/var/www/cgi-bin/test_proj/test_proj')

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "test_proj.settings")

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()

EOF
#wsgi.pyの設定ここまで

#setting.pyのALLOWED_HOSTSを編集
echo "ALLOWED_HOSTS = ['*']" >> /var/www/cgi-bin/test_proj/test_proj/setting.py

echo "<<<<<<<<<<<<<<<<<<<< setting complete! >>>>>>>>>>>>>>>>>>" >> /root/setting.log 
echo "<<< setting complete! >>>"

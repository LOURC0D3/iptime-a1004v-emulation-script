#!/bin/bash

mkdir ~/work_directory
cd ~/work_directory

wget "https://download.iptime.co.kr/online_upgrade/a1004v_ml_12_162.bin"

sudo apt update
sudo apt install qemu-user-static binwalk -y

sudo binwalk -e a1004v_ml_12_162.bin -1 --run-as=root

cd ~/work_directory/_a1004v_ml_12_162.bin.extracted/squashfs-root

sudo cp /usr/bin/qemu-mipsel-static ./usr/bin

sudo cp -r ./default/* ./tmp/
sudo rm ./tmp/var/boa_vh.conf

cat << 'EOF' > ./tmp/var/boa_vh.conf
Port 80
User root
Group root
ServerAdmin root@localhost
VirtualHost
DocumentRoot /home/httpd
UserDir public_html
DirectoryIndex index.html
KeepAliveMax 100
KeepAliveTimeout 10
MimeTypes /etc/mime.types
DefaultType text/plain
AddType application/x-httpd-cgi cgi
AddType text/html html
ScriptAlias /sess-bin/ /cgibin/
ScriptAlias /cgi-bin/ /cgibin/
ScriptAlias /nd-bin/ /ndbin/
ScriptAlias /login/ /cgibin/login-cgi/
ScriptAlias /ddns/ /cgibin/ddns/
ServerName ""
SinglePostLimit 4194304
Auth /cgi-bin /etc/httpd.passwd
Auth /main /etc/httpd.passwd
EOF

sudo chroot . /usr/bin/qemu-mipsel-static ./sbin/httpd

echo "All tasks done."
echo "http://localhost"
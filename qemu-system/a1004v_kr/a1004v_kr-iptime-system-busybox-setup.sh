#!/bin/bash

cd ~/
tar xvf ./squashfs-root.tar
cd ./squashfs-root

cp -r ./default/* ./tmp/
rm ./tmp/var/boa_vh.conf

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

cd ~/squashfs-root

chroot ./ ./sbin/httpd

echo "All tasks done."
echo "http://localhost:3080"
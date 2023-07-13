#!/bin/bash

mkdir ~/work_directory

cp ./iptime-system-busybox-setup.sh ~/work_directory/iptime-system-busybox-setup.sh

cd ~/work_directory

wget "https://people.debian.org/~aurel32/qemu/mipsel/vmlinux-2.6.32-5-4kc-malta"
wget "https://people.debian.org/~aurel32/qemu/mipsel/debian_squeeze_mipsel_standard.qcow2"
wget "http://download.iptime.co.kr/online_upgrade/a1004v_kr_12_024.bin"

sudo apt update
sudo apt install qemu-system-mipsel binwalk -y

sudo binwalk -e a1004v_kr_12_024.bin -1 --run-as=root
cd ~/work_directory/_a1004v_kr_12_024.bin.extracted/
tar -cvf squashfs-root.tar squashfs-root/

qemu-system-mipsel -daemonize -M malta -kernel ~/work_directory/vmlinux-2.6.32-5-4kc-malta --hda ~/work_directory/debian_squeeze_mipsel_standard.qcow2 -append "root=/dev/sda1 console=tty0" -nic user,hostfwd=tcp::3080-:80,hostfwd=tcp::2222-:22

sudo echo "MACs hmac-md5,hmac-sha1,umac-64@openssh.com" >> /etc/ssh/ssh_config
sudo echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc" >> /etc/ssh/ssh_config
sudo echo "HostkeyAlgorithms ssh-dss,ssh-rsa" >> /etc/ssh/ssh_config
sudo echo "KexAlgorithms +diffie-hellman-group1-sha1" >> /etc/ssh/ssh_config

sleep 60
echo "Waiting for 60 seconds for the system to boot up."

scp -P 2222 ~/work_directory/_a1004v_kr_12_024.bin.extracted/squashfs-root.tar ~/work_directory/iptime-system-busybox-setup.sh root@localhost:/root

ssh root@localhost -p 2222 "chmod +x /root/iptime-system-busybox-setup.sh; /root/iptime-system-busybox-setup.sh"

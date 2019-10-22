#!/bin/bash

#現在動作検証中です。動作保証はできません。
#ラズパイ3B+上のRaspbianからSDカードに書き込みます。ラズパイ3B+にカードリーダーをセットしてください。
#例によってトラップだらけです。初心者には厳しいでしょう。このスクリプトもうまくいくか保証できません。
#RaspbianでSDカードをつなぐと/dev/sdaと認識されるはずです。
#以下では/dev/sdaと決め打ちで実行します。変更した場合は適宜変更してください。
#
#

echo "現在のディスク情報を表示します。"
fdisk -l

#ホームディレクトリで作業する。絶対に/ディレクトリでは作業しないこと。
cd

umount /dev/sda

parted -s $SDCARD unit s print
parted -s $SDCARD mktable msdos
parted -s $SDCARD mkpart primary fat32 8192s 128MiB
parted -s $SDCARD mkpart primary 128MiB 100%
parted -s $SDCARD unit s print


mkfs.vfat /dev/sda1
mkdir boot
mount /dev/sda1 boot

mkfs.ext4 /dev/sda2
mkdir root
mount /dev/sda2 root

wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root

#通常ここで止まるはずです。bsdtarコマンドはRaspbianに入ってません。インストールする必要があります。
apt-get install bsdtar

#再度実行
bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root
#ここで以下のようなエラーが出て停止します。
#bsdtar: Error exit delayed from previous errors.
#しかし無視して続行します。
#GNUのtarでもいけるという情報がありますが、検証してません。bsdtarとGNUtarの違いに詳しくないので現時点では何ともいえません。
#無視して続行してもインストールは可能です。
#

sync
mv root/boot/* boot
umount boot root

#インストールは以上で完了です。リブートして以下を実行します。
echo "pacman-key --initを実行してください"
echo "pacman-key --populate archlinuxarmを実行してください"
echo "pacman -Syuを実行してください"
#これを実行しないとpacmanが使えません。

#続いてLXDEをインストールします。
#pacman -S xf86-video-fbdev lxde xorg-xinit dbus
#ホームディレクトリに.xinitrcを作成します。
#echo "exec startlxde" > ~/.xinitrc
#リブートします。

#リブート後ログインしてstartxすればLXDEが起動します。

#!/bin/bash

#
#現在動作検証中です。動作保証はできません。
#ラズパイ3B+上のRaspbianからSDカードに書き込みます。ラズパイ3B+にカードリーダーをセットしてください。
#例によってトラップだらけです。初心者には厳しいでしょう。このスクリプトもうまくいくか保証できません。
#RaspbianでSDカードをつなぐと/dev/sdaと認識されるはずです。
#以下では/dev/sdaと決め打ちで実行します。変更した場合は適宜変更してください。
#インストールイメージは32bit環境を使用しました。
#

echo "現在のディスク情報を表示します。"
fdisk -l

#ホームディレクトリで作業する。絶対に/ディレクトリでは作業しないこと。
#/で作業した場合、タイプミスすると起動しなくなる可能性があります。
cd

umount /dev/sda

parted -s /dev/sda unit s print
parted -s /dev/sda mktable msdos
parted -s /dev/sda mkpart primary fat32 8192s 128MiB
parted -s /dev/sda mkpart primary 128MiB 100%
parted -s /dev/sda unit s print


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

#インストールは以上で完了です。
#カードリーダーを取り外し、ラズパイにSDカードをセットします。
#ブートします。初期ユーザはalarm(パスワードalarm)とroot(パスワードroot)です。
#初期ユーザのパスワードは変更しておきましょう。
#ログイン後に以下を実行します。
echo "pacman-key --initを実行してください"
echo "pacman-key --populate archlinuxarmを実行してください"
echo "pacman -Syuを実行してください"
#これを実行しないとpacmanが使えません。

#続いてLXDEをインストールします。
#pacman -S xf86-video-fbdev lxde xorg-xinit dbus
#パッケージの選択などいくつか質問されますが、全てEnterかyを入力します。
#ホームディレクトリに.xinitrcを作成します。
#echo "exec startlxde" > ~/.xinitrc
#リブートします。

#リブート後ログインしてstartxすればLXDEが起動します。

#
#
#以下はLXDEの日本語環境設定です。
#(1)キーマップ変更
#loadkeys jp106
#
#(2)タイムゾーン設定
#timedatectl set-timezone Asia/Tokyo
#
#(3)ロケール変更(LXDEメニューが日本語になります)
#/etc/locale.confにLANG=ja_JP.UTF-8を追加。
#
#(4)日本語フォントのインストール
#pacman -S otf-ipafont
#
#(5)mozcのインストール
#pacman -S fcitx-im fcitx-configtool fcitx-mozc
#
#(6).xprofile作成
#~/.xprofileを作成しfcitxの設定を記述する。
#書き方はいろんなサイトに書いてあります。
#この後GUI画面でさらに設定する必要があります。
#
#

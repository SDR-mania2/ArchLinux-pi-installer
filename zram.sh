#!/bin/sh
#
# Arch Wiki からのコピーです。on/offを入力してください。
# 手動でon/offしないとすぐにメモリが足りなくなります。
# 実行時にsudoをつける!
# 固まったらCtrl+Alt+F2 -> pkill -9 firefox -> pkill -9 i3
# -> pkill xinit -> poweroff
#

echo -n "Input on or off:"
read param

if [ $param = "on" ]; then

# enable zram
modprobe zram
echo lz4 > /sys/block/zram0/comp_algorithm
echo 200M > /sys/block/zram0/disksize
mkswap --label zram0 /dev/zram0
swapon --priority 100 /dev/zram0

fi


if [ $param = "off" ]; then

# disable zram
swapoff /dev/zram0
rmmod zram
# or reboot!

fi

free -h
zramctl
exit 0


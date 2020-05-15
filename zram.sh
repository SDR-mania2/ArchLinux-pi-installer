#!/bin/sh
#
# Arch Wiki からのコピーです
# 実行時にsudoをつける!
# 固まったらCtrl+Alt+F2 -> pkill firefox -> poweroff
#

# enable zram
modprobe zram
echo lz4 > /sys/block/zram0/comp_algorithm
echo 100M > /sys/block/zram0/disksize
mkswap --label zram0 /dev/zram0
swapon --priority 100 /dev/zram0

# disable zram
# swapoff /dev/zram0
# rmmod zram
# or reboot!


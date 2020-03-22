#!/bin/sh
# コマンド打つのが面倒になって作ったシェルスクリプトです。 
# 実行後archかraspbianを入力すると、コアダンプ情報を表示します。
# 次にjournalctlでログを表示して、qを押すとCPU温度とCPU周波数を5秒間隔で表示します。
# CPU周波数は4コアすべて表示します。
# とにかく止まったらqを押してください。
# 終了はCtl-cでお願いします。Archでしか動作検証していませんが、多分Busterでも動くはず。


print_temp () {

  if [ $distro = "raspbian" ]; then
    vcgencmd measure_temp

  elif [ $distro = "arch" ]; then
    /opt/vc/bin/vcgencmd measure_temp

  else
    echo "不正な値: $distro"
    exit 1

  fi
}


print_hz () {

  for i in $(seq 0 3)
  do
    cat /sys/devices/system/cpu/cpu$i/cpufreq/scaling_cur_freq
  done

}


echo -n "Input your distro,arch or raspbian:"
read distro
coredumpctl list
coredumpctl info -1

sleep 1
echo "----- Press q to continue -----"
journalctl SYSLOG_IDENTIFIER=systemd-coredump -o verbose
journalctl -e
# journalctl -u ufw
# journalctl -u sshd

# ulimit -m 921000
# ulimitでメモリ使用量を制限します。921000kBで約900MBです。
# これを超えるとブラウザ等は終了します。コアダンプしますが端末は落ちません。
# ulimitは端末で直接実行するか、.bashrcに書かないと機能しません。
# ulimit -a

while [ true ];

do

  echo -n $(
  print_temp;
  print_hz;
  )

  if [ $distro != "arch" ] && [ $distro != "raspbian" ]; then
    exit 1
  fi

  echo ":kHz"
  sleep 5

done

exit 0



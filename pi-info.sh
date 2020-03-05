#!/bin/sh

# kairyou sita  script!



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



# See /boot/overlays/README for all available options

gpu_mem=64
initramfs initramfs-linux.img followkernel


hdmi_group=2
hdmi_mode=87
hdmi_drive=2
hdmi_cvt=1024 600 60 6

dtparam=audio=on
# use "alsamixer" command to control volume!
# alsamixerと入力するだけで音量調節可能。
# USB boot for Xiegu GSOC

# 1. Prepare SD card.

Please follow official(?) firmware upgrade procedure and burn image.
(sdcard.img) to your SD card. For example:.
```
dd if=sdcard.img of=/dev/sdXXX bs=8M
```

Where sdXXX is SD device recognized by a kernel. If unsure please execute
`dmesg` and find out in kernel messages.

## 2. Script for uBoot on SD card

This script will switch boot device from SD card to USB.

Compile:
```
mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d uboot.script boot.scr
```
and overwrite `boot.scr` file on the firmware update SD card (first partition).
For example:
```
mount /dev/sdXXX1 /mnt
cp boot.scr /mnt
umount /mnt
```

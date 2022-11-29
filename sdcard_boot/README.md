# SD card boot for Xiegu GSOC

The purpose of this document is to preapare SD card for new Debian system.

## 1. Prepare SD card.

Please follow official(?) firmware upgrade procedure and burn image 
(sdcard.img) to your SD card. For example: 
```
dd if=sdcard.img of=/dev/sdXXX bs=8M

```
Where sdXXX is SD device recognized by a kernel. If unsure please execute
`dmesg` and find out in kernel messages.

## 2. Script for uBoot on SD card

This script will disable device renaming by the kernel and makes output 
to tty1 instead of ttyS0

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

## 3. Prepare partition

Once the SD card is flashed use you favorite partitioning tool and remove 
`/dev/sdXXX2` and `/dev/sdXXX3` partitions. Then create new Linux partition 
with ext4 filesystem on it. It should become `/dev/sdXXX2`. My preffered tool 
of choice is `cfdisk`, as it's interacive and is much user friendly than 
`fdisk`. If everything went well one should have SD card with two partitions:
- /dev/sdXXX1 with `uImgae`, `boot.scr`, `xiegu-a20-gsoc.dtb` 
- /dev/sdXXX2 which should be empty

Depending on a tool used for creating second partition, filesystem creation 
might be required. If unsure please run:
```
mkfs.ext4 /dev/sdXXX2
```

Note: Change XXX to a letter assigned by the operaing system. If unsure 
type `dmesg` and find out in kernel messages. 

## 4. Write Debian to SD card

Copy your Debian distro files to the empty partition on your SD card 
... and that's it. Pendrive should be ready to use.

For Debian creation please refer to [this](../debian) section.

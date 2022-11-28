# USB boot for Xiegu GSOC

## Script for uBoot on SD card

This script will switch bootdevice from SCdard to USB. 

Compile:

```
mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d uboot.script boot.scr
```
and overwrite `boot.scr` file on the firmware update card (first partition).


# USB boot for Xiegu GSOC

The purpose of this document is to boot kernel from USB device and set it up
to use /dev/sda2 (from USB) as root folder for operating system. During my 
research it turned out that using USB pendrive was much easier to operate than
SD card. SD card lifespan and resilience to writes migh also be a turning point.

## 1 Prepare SD card uBoot scrip.

Please refer to [this section](../sdcard_for_usb) for details.


## 2 Prepare and Compile USB uBoot script

```
mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d uboot.script boot.scr

```
As a result boot.scr should be created.


## 3 Prepare USB pendrive

### 3.a. Write and modify base image

The easiest way so far is to use original firmware update file (`sdcard.img`)
and flash USB pendrive. The funny thing is that Xiegu doesn't provide this 
image on cqxiegu.com website. You have to google for yorself and download it
from one of the resellers website. Once the pendrive is flashed use you favorite
partitioning tool and remove `/dev/sdXXX2` and `/dev/sdXXX3` partitions. Then 
create new Linux partition with ext4 filesystem on it. It should become 
`/dev/sdXXX2`. My preffered tool of choice is `cfdisk`, as it's interacive and 
is much user friendly than `fdisk`. If everything went well one should have USB 
stick with two partitions: 
- /dev/sdXXX1 with `uImgae`, `boot.scr`, `xiegu-a20-gsoc.dtb` 
- /dev/sdXXX2 which should be empty

Now overwrite `boot.scr` with file generated in step **no.2**

Note: Change XXX to a letter assigned by the operaing system. If unsure 
type `dmesg` and find out in kernel messages. 


### 3.b. Write Debian to USB stick

Unpack your Debian distro archive to the empty partition on your USB stick
... and that's it. Pendrive should be ready to use.

Note: Both SD card and USB stick must be present during boot.

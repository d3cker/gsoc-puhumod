# Debian for Xiegu GSOC a.k.a puhuMod

The purpose of this script is to make Debian creating process a little more
automated. 

## 1. Prerequisites
* Linux host (no suprise here. I used Ubuntu 22.04)
* debootstrap and qemu-user-static
* ~2GB of free space

If debootstap and qemu-user-static are missing, please install them first:

```
sudo apt-get install debootstrap qemu-user-static binfmt-support
```

## 2. Build

The script should do the job. In theory no additional actions should be required. 
As a root simply run:

```
./make_puhu.sh /somepath
```

This automated process is responsible for: 

* creating base system
* adding extra repositories
* installing Xorg, IceWM , OpenBox (preffered) and libraries required by GSOC app
* creating posinstall and network scripts

## 3. Install and boot

For instructions how to prepeare storage for installing newly created Debian 
distro please refer to [USB](../usb_boot) or [SD](../sdcard_boot) section.
Once the storage is ready please copy all files created by this script 
to second (empty) partition. For example:

```
mount /dev/sdXXX2 /mnt/
cp -r /somepath/* /mnt/
umount /mnt
```

### 4. First run

Default root password is set to `gsoc`. Please log in as root and execute
`postinstall.sh` script. The script will copy: 
* kernel modules from GSOC storage to `/lib/modules`
* `gsoc_app_v1` binary to `/usr/local/gsoc`
* `asoun.conf` to `/etc` . This one is required by Alsa and GSOC app
Type `reboot` once finished.

## 5. Second and next runs

Please log in to terminal and type:
```
startx
```
OpenBox should be started. Give it a few seconds to create default directories
and right click on a desktop to verify it's working. Menu should pop up.


## 6. Network

Due to some issues with network driver, NetworkManager is not used.
Edit `/etc/wpa_supplicant/wpa_supplicant.conf` and set up you WiFi credentials.
Two scripts are created in `/root` folder: `wpa.sh` and `dhc.sh`.
First execute `./wpa.sh` and then in a second terminal run `./dhc.sh`.
If you receive authentication timeout on `wpa.sh` then disconnect your USB
wifi adapter, connect again and restart `./wpa.sh`. Sometimes it takes more
than one time to make it work.


## A. Wifi hardware

Ammount of supported hardware is limited at this moment. Please take a look 
at `/lib/modules` to find out what might work. Cards with chipsets other than
Realtek won't work. I can confirm that TP-Link TL-WN821N works.
(https://www.amazon.pl/gp/product/B00194XKXA/)

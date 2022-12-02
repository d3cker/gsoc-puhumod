#!/bin/bash

if [ -z "${1}" ]; then
    echo "Argument required. Please provide path for new Debian distro"
    echo "Usage: ${0} </absolute/path>"
    exit
fi

DESTPATH=${1}

if [ -d ${DESTPATH} ]; then
    echo "Folder already exists.Aborting"
    exit
fi


if [ ! -f /usr/bin/qemu-arm-static ]; then 
    echo "Missing qemu-arm-static. Please install."
    exit
fi

if [ ! -f /usr/sbin/debootstrap ]; then 
    echo "Missing debootstrap. Please install."
    exit
fi

if [ ! -f /usr/sbin/update-binfmts ]; then
    echo "Missing binfmt-support.  Please install."
    exit
fi

debootstrap --no-check-gpg --arch=armhf --include=ssh --foreign bullseye ${DESTPATH} ftp://ftp.ca.debian.org/debian

cp /usr/bin/qemu-arm-static ${DESTPATH}/usr/bin

chroot ${DESTPATH} /debootstrap/debootstrap --second-stage

echo "deb http://deb.debian.org/debian bullseye main contrib non-free" > ${DESTPATH}/etc/apt/sources.list
echo "deb http://deb.debian.org/debian bullseye-backports main contrib non-free" >> ${DESTPATH}/etc/apt/sources.list

chroot ${DESTPATH} apt update

echo "gsoc-puhu" > ${DESTPATH}/etc/hostname

echo "/dev/root     /               ext4    errors=remount-ro 0       1" > ${DESTPATH}/etc/fstab

cat << EOF | chroot ${DESTPATH} /bin/bash
export DEBIAN_FRONTEND=noninteractive
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
apt-get -y install mc firmware-realtek wpasupplicant xorg openbox icewm feh locales alsa-utils libqt5multimedia5 libqt5bluetooth5 libqt5sql5 libatomic1 libqt5serialport5 libliquid-dev libcodec2-0.9
locale-gen en_US.UTF-8
dpkg-reconfigure locales
EOF

echo "network={
ssid=\"your_ssid\"
psk=\"your_psk\"
}
" > ${DESTPATH}/etc/wpa_supplicant/wpa_supplicant.conf


if [ -f images/openbox.jpeg ]; then 
  mkdir ${DESTPATH}/usr/share/wallpapers
  cp images/openbox.jpeg ${DESTPATH}/usr/share/wallpapers
  echo "feh --bg-scale /usr/share/wallpapers/openbox.jpeg
exec /usr/bin/openbox-session" > ${DESTPATH}/root/.xinitrc
else 
  echo "exec /usr/bin/openbox-session" > ${DESTPATH}/root/.xinitrc
fi

echo "wpa_supplicant -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf" > ${DESTPATH}/root/wpa.sh
echo "dhclient wlan0"  > ${DESTPATH}/root/dhc.sh

echo "#!/bin/bash
echo Mounting local GSOC storage
mount /dev/mmcblk1p2 /mnt/
echo Modules
cp -r /mnt/lib/modules /lib
echo Xiegu GSOC QT5 app
cp -r /mnt/usr/local/gsoc /usr/local
echo Alsa config
cp /mnt/etc/asound.conf /etc/
echo Now please reboot

" > ${DESTPATH}/root/postinstall.sh

chmod +x ${DESTPATH}/root/*.sh

cat << EOF | chroot ${DESTPATH} /bin/bash
echo -en "gsoc\ngsoc\n" | passwd root
EOF

rm ${DESTPATH}/usr/bin/qemu-arm-static

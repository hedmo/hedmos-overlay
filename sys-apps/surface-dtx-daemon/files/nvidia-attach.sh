#!/usr/bin/env sh
if [ -e "/sys/bus/pci/devices/0000:00:1d.4/rescan" ]; then
    echo 1 > /sys/bus/pci/devices/0000:00:1d.4/rescan
fi

modprobe nvidia 2>/dev/null
mknod -m 600 /dev/nvidiactl c 195 255 2>/dev/null; chown root:video /dev/nvidiactl
mknod -m 600 /dev/nvidia0 c 195 0 2>/dev/null; chown root:video /dev/nvidia0
mknod -m 600 /dev/nvidia-modeset c 195 254 2>/dev/null; chown root:video /dev/nvidia-modeset

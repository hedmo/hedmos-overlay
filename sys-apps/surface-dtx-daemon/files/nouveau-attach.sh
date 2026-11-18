#!/usr/bin/env sh
# surface-dtx attachment handler

# Rescan PCIe root port to detect reattached GTX 1650
if [ -e "/sys/bus/pci/devices/0000:00:1d.4/rescan" ]; then
    echo 1 > /sys/bus/pci/devices/0000:00:1d.4/rescan
fi

# Wait briefly for udev to create DRM nodes, then grant user ACL
sleep 1
/usr/bin/setfacl -m u:hedmo:rw /dev/dri/by-path/pci-0000:02:00.0-* 2>/dev/null

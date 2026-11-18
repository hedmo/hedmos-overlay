#!/usr/bin/env sh
EXIT_DETACH_COMMENCE=0
EXIT_DETACH_ABORT=1

USER_NAME="hedmo"
USER_ID=$(id -u "$USER_NAME")
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"
NOTIFY_TAG="--hint=string:x-canonical-private-synchronous:surface-dtx"

PCI_ADDR="0000:02:00.0"
PCI_PATH="/sys/bus/pci/devices/0000:00:1d.4/$PCI_ADDR"

if [ ! -d "$PCI_PATH" ]; then
    exit $EXIT_DETACH_COMMENCE
fi

read dgpu_state < "$PCI_PATH/power_state"

if [ "$dgpu_state" != "D3cold" ]; then
    sudo -u "$USER_NAME" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
        DISPLAY=:0 notify-send $NOTIFY_TAG -u normal -t 3000 \
        "Detach Blocked" \
        "E-GPU is Active ( $dgpu_state ). Close active 3D apps first."
    exit $EXIT_DETACH_ABORT
fi

modprobe -r nvidia_uvm nvidia_drm nvidia_modeset nvidia 2>/dev/null
echo 1 > "$PCI_PATH/remove" 2>/dev/null

for usb_dev in /dev/disk/by-id/usb-*
do
    [ -e "$usb_dev" ] || continue
    dev=$(readlink -f "$usb_dev")
    if mount -l | grep -q "^$dev\s"; then
        umount -l "$dev" 2>/dev/null
    fi
done

exit $EXIT_DETACH_COMMENCE

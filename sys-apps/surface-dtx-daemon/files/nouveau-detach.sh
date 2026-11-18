#!/usr/bin/env sh
# SB3-Nouveau Detach Handler: Optimized for 7.0-rc2 GSP Patch

EXIT_DETACH_COMMENCE=0
EXIT_DETACH_ABORT=1

# 1. Setup Notification Environment
USER_NAME="hedmo"
USER_ID=$(id -u "$USER_NAME")
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"

# Tag to replace existing notifications (prevents screen spam)
NOTIFY_TAG="--hint=string:x-canonical-private-synchronous:surface-dtx"

# 2. Identify the GPU Path
# Matching your verified dmesg address
PCI_ADDR="0000:02:00.0"
PCI_PATH="/sys/bus/pci/devices/0000:00:1d.4/$PCI_ADDR"

# If device is already gone, just exit successfully
if [ ! -d "$PCI_PATH" ]; then
    exit $EXIT_DETACH_COMMENCE
fi

# 3. Handle GPU State Check
read dgpu_state < "$PCI_PATH/power_state"

if [ "$dgpu_state" != "D3cold" ]; then
    # Use 'normal' urgency so the 3000ms timeout is respected by the desktop
    sudo -u "$USER_NAME" DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
        DISPLAY=:0 notify-send $NOTIFY_TAG -u normal -t 3000 \
        "Detach Blocked" \
        "E-GPU is Active ( $dgpu_state ). Close active 3D apps first."
    exit $EXIT_DETACH_ABORT
fi

# 4. Driver Unbind & PCI Remove (Triggers your 2s patch on next attach)
# Wake briefly for a clean unbind
echo "on" > "$PCI_PATH/power/control" 2>/dev/null
if [ -d "$PCI_PATH/driver" ]; then
    echo "$PCI_ADDR" > "$PCI_PATH/driver/unbind" 2>/dev/null
fi
# Remove device from bus
echo 1 > "$PCI_PATH/remove" 2>/dev/null

# 5. Unmount USB devices
for usb_dev in /dev/disk/by-id/usb-*
do
    [ -e "$usb_dev" ] || continue
    dev=$(readlink -f "$usb_dev")
    if mount -l | grep -q "^$dev\s"; then
        umount -l "$dev" 2>/dev/null
    fi
done

# 6. Success (Silent - Latch sound is the confirmation)
exit $EXIT_DETACH_COMMENCE

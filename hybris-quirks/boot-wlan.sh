#!/bin/sh

[ -e /sys/kernel/boot_wlan/boot_wlan ] && echo 1 > /sys/kernel/boot_wlan/boot_wlan

[ -e /dev/wlan ] && echo ON > /dev/wlan

[ -e /dev/wmtWifi ] && echo 1 > /dev/wmtWifi

exit 0

#!/bin/sh

echo 1 > /dev/wcnss_wlan
echo sta > /sys/module/wlan/parameters/fwpath

exit 0

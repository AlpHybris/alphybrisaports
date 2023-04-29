#!/bin/bash

input="$1"

while IFS= read -r line; do
    kernel=$(echo "$line" | grep -o 'KERNEL=="[^"]*' | cut -d'"' -f2)
    action=$(echo "$line" | grep -o 'ACTION=="[^"]*' | cut -d'"' -f2)

    if echo "$line" | grep -q 'OWNER'; then
        owner=$(echo "$line" | sed 's/.*OWNER="\([^"]*\).*/\1/' | awk '{print $1}')
    else
        owner=""
    fi

    if echo "$line" | grep -q 'GROUP'; then
        group=$(echo "$line" | sed 's/.*GROUP="\([^"]*\).*/\1/' | awk '{print $1}')
    else
        group=""
    fi

    if echo "$line" | grep -q 'MODE'; then
        mode=$(echo "$line" | sed 's/.*MODE="\([^"]*\).*/\1/' | awk '{print $1}')
    else
        mode=""
    fi

    if echo "$line" | grep -q 'SYMLINK'; then
        symlink=$(echo "$line" | sed 's/.*SYMLINK+="\([^"]*\).*/\1/' | awk '{print $1}')
    else
        symlink=""
    fi

#    echo "kernel: $kernel"
#    echo "action: $action"
#    echo "owner: $owner"
#    echo "group: $group"
#    echo "mode: $mode"

    if [ ! -z "$symlink" ]; then
        mkdir -p "/dev/$(dirname $symlink)"
        ln -sf "/dev/$kernel" "/dev/$symlink"
        echo "Created symlink from /dev/$kernel to /dev/$symlink"
    fi

    if [ -n "$kernel" ] && [ -n "$mode" ]; then
        if [ -e "/dev/$kernel" ]; then
           if [ -z  "$owner" ] && [ -z "$group" ]; then
              chmod "$mode" -R "/dev/$kernel"
              echo "Applied permissions for /dev/$kernel with mode $mode"
           elif [ ! -z  "$owner" ] && [ ! -z "$group" ]; then
              if  [ ! -z "$mode" ]; then
                 chmod "$mode" -R "/dev/$kernel"
                 chown "$owner:$group" -R "/dev/$kernel"
                 echo "Applied permissions for /dev/$kernel with mode $mode, owner $owner, and group $group"
              else
                 chown "$owner:$group" -R "/dev/$kernel"
                 echo "Applied permissions for /dev/$kernel with owner $owner, and group $group"
              fi
           elif [ -z "$owner" ] && [ ! -z "$group" ]; then
              if  [ ! -z "$mode" ]; then
                 chmod "$mode" -R "/dev/$kernel"
                 chgrp "$group" -R "/dev/$kernel"
                 echo "Applied permissions for /dev/$kernel with mode $mode, and group $group"
              else
                 chgrp "$group" -R "/dev/$kernel"
                 echo "Applied permissions for /dev/$kernel with group $group"
              fi
           fi
        fi
    fi
done < "$input"

chmod 666 /dev/tty*

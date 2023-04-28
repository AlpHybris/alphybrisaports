#!/bin/bash

input="$1"

while IFS= read -r line; do
    kernel=$(echo "$line" | grep -o 'KERNEL=="[^"]*' | cut -d'"' -f2)
    owner=$(echo "$line" | sed 's/.*OWNER="\([^"]*\).*/\1/' | awk '{print $1}')
    group=$(echo "$line" | sed 's/.*GROUP="\([^"]*\).*/\1/' | awk '{print $1}')
    mode=$(echo "$line" | sed 's/.*MODE="\([^"]*\).*/\1/' | awk '{print $1}')

    if [ -n "$kernel" ] && [ -n "$mode" ]; then
        if [ -e "/dev/$kernel" ]; then
           chmod "$mode" -R "/dev/$kernel"
           chown "$owner:$group" -R "/dev/$kernel"
           echo "Applied permissions for /dev/$kernel with mode $mode, owner $owner, and group $group"
        fi
    else
        echo "Error: KERNEL or MODE not found in line: $line"
    fi
done < "$input"

chmod 666 /dev/tty7

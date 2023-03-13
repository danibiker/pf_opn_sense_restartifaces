#!/bin/sh

wanip=$(ifconfig ue0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
IDs=$(usbconfig list | grep Xiaomi | sed -r 's/ugen([0-9]\.[0-9]).*/\1/')


if [ -z "$wanip" ]
then
     echo `date +%Y%m%d.%H%M%S` "Resetting interface."  >> ~/renewout.log
     #usbconfig -d 1.2 set_config 1 ~/renewout.log
     for ID in $IDs
     do
        usbconfig -d $ID set_config 1
     done
     dhclient ue0 >> ~/renewout.log
#else
#     echo $wanip is NOT empty >> ~/renewout.log
fi

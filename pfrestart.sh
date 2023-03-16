#!/bin/sh

BOUNCE=ue0
wanip=$(ifconfig $BOUNCE | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
IDs=$(usbconfig list | grep Xiaomi | sed -r 's/ugen([0-9]\.[0-9]).*/\1/')
DEST="www.google.es"

if [ -z "$wanip" ]
then
     echo `date +%Y%m%d.%H%M%S` "Resetting interface."  >> ~/renewout.log
     #usbconfig -d 1.2 set_config 1 ~/renewout.log
     for ID in $IDs
     do
        usbconfig -d $ID set_config 1 >> ~/renewout.log 2>> ~/renewout.log
        usbconfig -d $ID set_config 0 >> ~/renewout.log 2>> ~/renewout.log
        ifconfig $BOUNCE down >> ~/renewout.log 2>> ~/renewout.log
        ifconfig $BOUNCE up >> ~/renewout.log 2>> ~/renewout.log
     done
     dhclient $BOUNCE >> ~/renewout.log

     echo `date +%Y%m%d.%H%M%S` "Pinging $DEST" >> $LOGFILE
     ping -c1 $DEST  >> ~/renewout.log 2>> ~/renewout.log
     if [ $? -eq 0 ]
     then
        echo `date +%Y%m%d.%H%M%S` "Ping $DEST OK." >> $LOGFILE
        service netif restart && service routing restart
     fi

#else
#     echo $wanip is NOT empty >> ~/renewout.log
fi

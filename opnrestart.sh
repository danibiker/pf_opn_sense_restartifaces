#!/bin/sh

BOUNCE=ue0
wanip=$(ifconfig $BOUNCE | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
IDs=$(usbconfig list | grep Xiaomi | sed -r 's/ugen([0-9]\.[0-9]).*/\1/')
DEST="www.google.com"
LOGFILE=~/renewout.log
CMD_RELOAD="/usr/local/etc/rc.reload_all"

if [ -z "$wanip" ]
then
     echo `date +%Y%m%d.%H%M%S` "Resetting interface."  >> $LOGFILE
     usbconfig -d 1.2 set_config 1 ~/renewout.log
     for ID in $IDs
     do
        usbconfig -d $ID set_config 1 >> $LOGFILE 2>> $LOGFILE
        usbconfig -d $ID set_config 0 >> $LOGFILE 2>> $LOGFILE
        ifconfig $BOUNCE down >> $LOGFILE 2>> $LOGFILE
        ifconfig $BOUNCE up >> $LOGFILE 2>> $LOGFILE
     done
     dhclient $BOUNCE >> $LOGFILE

     echo `date +%Y%m%d.%H%M%S` "Pinging $DEST" >> $LOGFILE
     ping -c1 $DEST >> $LOGFILE 2>> $LOGFILE
     if [ $? -eq 0 ]
     then
        echo `date +%Y%m%d.%H%M%S` "Ping $DEST OK." >> $LOGFILE
        exec ${CMD_RELOAD}  >> $LOGFILE 2>> $LOGFILE
     fi

#else
#     echo $wanip is NOT empty >> $LOGFILE
fi

#!/bin/sh

BOUNCE=ue0
wanip=$(ifconfig $BOUNCE | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
waniperr=$(ifconfig $BOUNCE 2>&1)
IDs=$(usbconfig list | grep -e 'Google Pixel' -e Xiaomi | sed -r 's/ugen([0-9]\.[0-9]).*/\1/')
DEST="www.google.es"
LOGFILE=~/renewout.log
CMD_RELOAD="/usr/local/etc/rc.reload_all"

#contains(){
#        case $1 in
#                (*$2*) true;;
#                (*) false;;
#        esac
#}

#if contains "$waniperr" "does not exist"
#then
#       echo The wanip is: $wanip >> $LOGFILE
#       echo The error is: $waniperr >> $LOGFILE
#       echo La interfaz no existe >> $LOGFILE
#       exit
#fi


if [ -z "$wanip" ]
then
     echo `date +%Y%m%d.%H%M%S` "Resetting interface."  >> $LOGFILE
     trydhcp=0
     for ID in $IDs
     do
        usbconfig -d $ID set_config 1 >> $LOGFILE 2>> $LOGFILE
        usbconfig -d $ID set_config 0 >> $LOGFILE 2>> $LOGFILE
        ifconfig $BOUNCE down >> $LOGFILE 2>> $LOGFILE
        ifconfig $BOUNCE up >> $LOGFILE 2>> $LOGFILE
        trydhcp=1
     done
     if [ trydhcp -eq 1 ]
     then
        dhclient $BOUNCE >> $LOGFILE
        echo "Calling dhclient" >> $LOGFILE
                 echo `date +%Y%m%d.%H%M%S` "Pinging $DEST" >> $LOGFILE
                 ping -c1 $DEST >> $LOGFILE 2>> $LOGFILE
                 if [ $? -eq 0 ]
                 then
                        echo `date +%Y%m%d.%H%M%S` "Ping $DEST OK." >> $LOGFILE
                        exec ${CMD_RELOAD}  >> $LOGFILE 2>> $LOGFILE
                 fi
     fi
#else
#     echo $wanip is NOT empty >> $LOGFILE
fi


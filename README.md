# pfsenserestartifaces
Script to restart pfsense interfaces
------------------------------------

This script is intented to be run on a cron job, so it restores the connection when a usb interface with ethernet bridge is plugged in. In my case, I use a Xiaomi android phone, and used it to share the internet through usb. 
The only things to customize are the following lines

#Change this line to the name of the adapter interface that the usb creates  
BOUNCE=ue0 

#Change the name "Xiaomi" by the some string containing the device listed when executing the command >>usbconfig list  
IDs=$(usbconfig list | grep Xiaomi | sed -r 's/ugen([0-9]\.[0-9]).*/\1/')

Instructions
------------

1. copy the file to /usr/local/cron/restoreiface.sh
2. add the following line to the file /etc/cron.d/at to execute the script every 1 minute  
  */1     *     *     *     *     root     /usr/local/cron/restoreiface.sh
  



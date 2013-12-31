#!/bin/sh

NETWORK=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`
LOGFILE=~/Documents/backups.log
ROUTER=`arp router | grep en3 | cut -d ' ' -f 4`

if [[ ! -f $LOGFILE ]]
then
    `touch $LOGFILE`
fi

do_backup () {
    echo "`date` - [INFO] Starting backup of [Work] @ $NETWORK" >> $LOGFILE
    if rsync -vazP -e ssh --exclude '~/Documents/Work/pm' ~/Documents/Work/* root@emporium:/volume1/work
    then
        echo "`date` - [INFO] Backup of [Work] successful" >> $LOGFILE
        `date | cut -c -10 > ~/Documents/Work/.backup`
    else
        echo "`date` - [ERROR] Backup of [Work] failed" >> $LOGFILE
    fi
}

if [[ ! -f ~/Documents/Work/.backup ]]
then
    if [[ $NETWORK == "Quinc&Eef" || $ROUTER == "90:6e:bb:da:19:67" ]]
    then
        do_backup
    else
        echo "`date` - [ERROR] Not at my home network @ $NETWORK" >> $LOGFILE
    fi
else
    if [[ `cat ~/Documents/Work/.backup` == `date | cut -c -10` ]]
    then
        echo "`date` - [INFO] Backup already done today" >> $LOGFILE
    else
        echo "`date` - [INFO] Removing .backup file" >> $LOGFILE
        `rm ~/Documents/Work/.backup`
        if [[ $NETWORK == "Quinc&Eef" || $ROUTER == "90:6e:bb:da:19:67" ]]
        then
            do_backup
        else
            echo "`date` - [ERROR] Not at my home network @ $NETWORK" >> $LOGFILE
        fi
    fi
fi

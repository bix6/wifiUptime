#!/bin/bash

# Setup Vars
outfile="wifiUptime.log"
sleepTime=10

# 86400 seconds in a day / sleepTime makes it loop for a day
maxLoops=$((86400/$sleepTime))

wifiOn=false
toggleBool=false
i=0

# Log Start
# echo "Wifi Uptime..."
echo "$(date): Restart" >> $outfile

# Main program loop
while [ $i -le $maxLoops ]
do
        # echo $i

        # Get wifi status and set wifiOn bool
        # Otherwise log error
        if [ $(iwconfig 2>&1 | grep -c Bigbootybitches) -eq 1 ]
        then
                # echo "Setting wifiOn=true"
                wifiOn=true
        elif [ $(iwconfig 2>&1 | grep -c ESSID:off/any) -eq 1 ]
        then
                # echo "Setting wifiOn=false"
                wifiOn=false

        else
                echo "$(date): ERROR $(iwconfig 2>&1)" >> $outfile
        fi

        # Only log when the status changes using toggleBool
        # Also account for i = 0

        # TODO verify logic and potentially merge the if block from above into this block?

        if [ $toggleBool = false ] && [ $wifiOn = true ]
        then
                # echo "Logging wifi on bbb"
                echo "$(date): wifi on bbb" >> $outfile
                toggleBool=true
        elif [ $toggleBool = true ] || [ $i -eq 0 ] && [ $wifiOn = false ]
        then
                # echo "Logging WIFI OFF"
                echo "$(date): WIFI OFF" >> $outfile
                toggleBool=false
        fi

        # increment i and sleep
        i=$(( i+1 ))
        sleep $sleepTime
done

# Log loop exit
echo "$(date): Exited Loop i=$i" >> $outfile

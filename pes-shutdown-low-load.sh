#!/bin/bash
# Script to shutdown server.
# 1st check uptime > 10min
# 2nd check Load < 1, sleep 10min, if load < 1 shutdown
# Pieter Smit (c) 2021-03-17 - GPL-3
#
#Get load ave 1,5,15min
#set -xv
#DEBUG="TRUE"
function myecho {
   if [ ! -z "$DEBUG" ]
   then
     echo "$*"
   fi
}
IFS=" " read -r -a load <<< "$(cat /proc/loadavg)"
myecho "1min=${load[0]}  5min=${load[1]}  15min=${load[2]} "
#
function checkLoadBelowOne() {
  local total=0
  # add 1min and 5min load values.
  for i in 0 1 ;
  do
        #Bash only support integers
        total=$( echo "$total + ${load[i]}" | bc )
        myecho "function checkLoadBelowOne() i=$i ${load[i]} total=$total"
  done
  #return 0 if load<1
  return $( echo "${load[0]} > 1" |bc )
  }
#
function checkUptimeOver10min() {
    #Get uptime in seconds
    uptimesec="$(cat /proc/uptime | cut -d " " -f 1)"
    # return 0 for less that 10min
    myecho "function checkUptimeOver10min() uptimesec=$uptimesec"
    return $( echo "$uptimesec < (60*10)" |bc )
    }
#
#Check that uptime more than 10min
if checkUptimeOver10min ; then
    myecho "#uptime good $uptimesec>10min, check load"
    if checkLoadBelowOne ; then
            MSG="Server Load low - WARN: will stop server after 10min if load still low"
            myecho $MSG
            wall $MSGi
            sleep 600  # 10min = 600sec
            if checkLoadBelowOne; then
                    MSG="Server shutting down now due to low load"
                    myecho $MSG
                    wall $MSG
                    sudo /usr/sbin/shutdown -h +2 $MSG
            fi
    else
            myecho "#Load good check in next cron "
    fi
else
   myecho "#Not up long enough $(checkUptimeOver10min) #"
fi


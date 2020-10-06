#!/bin/sh

rmmod pseudortc 2>&1 >> /dev/null
insmod ../module/pseudortc.ko || (echo "insmod failed"; exit 1)

echo " "
echo "setting hwclock to current time"
hwclock -w -f /dev/rtc1 || (echo "set hwclock  failed"; exit 1)
echo "reading time"
printf "our clock is %s \n" "`hwclock -f /dev/rtc1`" > /dev/stdout & \
printf "system clock is %s \n" "`hwclock -f /dev/rtc0 `" > /dev/stdout
sleep 2
echo "sleeping 10 seconds"
sleep 8
printf "after sleep our clock is %s \n" "`hwclock -f /dev/rtc1`" > /dev/stdout & \
printf "after sleep system clock is %s \n" "`hwclock -f /dev/rtc0 `" > /dev/stdout
echo " "

sleep 1

echo " "
echo "going slower"
echo "slow" > /proc/driver/rtcspeed
echo " "
echo "setting hwclock to current time"
hwclock -w -f /dev/rtc1 || (echo "set hwclock  failed"; exit 1)
echo "reading time"
printf "our clock is %s \n" "`hwclock -f /dev/rtc1`" > /dev/stdout & \
printf "system clock is %s \n" "`hwclock -f /dev/rtc0 `" > /dev/stdout
sleep 2
echo "sleeping 10 seconds"
sleep 8
printf "after sleep our clock is %s \n" "`hwclock -f /dev/rtc1`" > /dev/stdout & \
printf "after sleep system clock is %s \n" "`hwclock -f /dev/rtc0 `" > /dev/stdout
sleep 1
echo " "


echo " "
echo "going faster"
echo "fast" > /proc/driver/rtcspeed
echo " "
echo "setting hwclock to current time"
hwclock -w -f /dev/rtc1 || (echo "set hwclock  failed"; exit 1)
echo "reading time"
printf "our clock is %s \n" "`hwclock -f /dev/rtc1`" > /dev/stdout & \
printf "system clock is %s \n" "`hwclock -f /dev/rtc0 `" > /dev/stdout
sleep 2
echo "sleeping 10 seconds"
sleep 8
printf "after sleep our clock is %s \n" "`hwclock -f /dev/rtc1`" > /dev/stdout & \
printf "after sleep system clock is %s \n" "`hwclock -f /dev/rtc0 `" > /dev/stdout
sleep 1
echo " "

echo " "
echo "going south"
echo "rand" > /proc/driver/rtcspeed
echo " "
echo "setting hwclock to current time"
hwclock -w -f /dev/rtc1 || (echo "set hwclock  failed"; exit 1)
echo "reading time"
printf "our clock is %s \n" "`hwclock -f /dev/rtc1`" > /dev/stdout & \
printf "system clock is %s \n" "`hwclock -f /dev/rtc0 `" > /dev/stdout
sleep 2
echo "sleeping 10 seconds"
sleep 8
printf "after sleep our clock is %s \n" "`hwclock -f /dev/rtc1`" > /dev/stdout & \
printf "after sleep system clock is %s \n" "`hwclock -f /dev/rtc0 `" > /dev/stdout
sleep 1
echo " "


exit 0


echo " "
echo "going slower"
echo "slow" > /proc/driver/rtcspeed
echo "setting hwclock to current time"
hwclock  -w -f /dev/rtc1 || (echo "set hwclock  failed"; exit 1)
echo "reading time"
printf "our clock is "
hwclock -f /dev/rtc1
printf "system clock is "
hwclock -f /dev/rtc0
echo "sleeping 10 seconds"
sleep 10
printf "after sleep our clock is "
hwclock -f /dev/rtc1
printf "after sleep system clock is "
hwclock -f /dev/rtc0
echo " "



echo "going slower"
echo "slow" > /proc/driver/rtcspeed
echo "reading time"
hwclock -f /dev/rtc1 && hwclock -f /dev/rtc0
echo "sleeping 10 seconds"
sleep 10
hwclock -f /dev/rtc1 && hwclock -f /dev/rtc0

echo "going random"
echo "random" > /proc/driver/rtcspeed
echo "reading time"
hwclock -f /dev/rtc1 && hwclock -f /dev/rtc0
echo "sleeping 10 seconds"
sleep 10
hwclock -f /dev/rtc1 && hwclock -f /dev/rtc0

echo "check out my /proc/driver/rtc"
cat /proc/driver/rtc

echo "unloading module"
rmmod pseudortc

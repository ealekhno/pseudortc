#!/bin/sh

rmmod pseudortc 2>&1 >> /dev/null
insmod ../module/pseudortc.ko || (echo "insmod failed"; exit 1)

echo " "
echo "setting hwclock to current time"
hwclock -w -f /dev/rtc1 || (echo "set hwclock  failed"; exit 1)
echo "reading time"
printf "our clock is %s \n" "`hwclock -f /dev/rtc1`" & \
printf "system clock is %s \n" "`hwclock -f /dev/rtc0 `"
sleep 2
echo "sleeping 10 seconds"
sleep 8
printf "after sleep our clock is %s \n" "`hwclock -f /dev/rtc1`" & \
printf "after sleep system clock is %s \n" "`hwclock -f /dev/rtc0 `"

sleep 1
echo " "

echo "going slower"
echo "slow" > /proc/driver/rtcspeed
echo " "
echo "setting hwclock to current time"
hwclock -w -f /dev/rtc1 || (echo "set hwclock  failed"; exit 1)
echo "reading time"
printf "our clock is %s \n" "`hwclock -f /dev/rtc1`" & \
printf "system clock is %s \n" "`hwclock -f /dev/rtc0 `"
sleep 2
echo "sleeping 10 seconds"
sleep 8
printf "after sleep our clock is %s \n" "`hwclock -f /dev/rtc1`" & \
printf "after sleep system clock is %s \n" "`hwclock -f /dev/rtc0 `"
sleep 1
echo " "


echo "going faster"
echo "fast" > /proc/driver/rtcspeed
echo " "
echo "setting hwclock to current time"
hwclock -w -f /dev/rtc1 || (echo "set hwclock  failed"; exit 1)
echo "reading time"
printf "our clock is %s \n" "`hwclock -f /dev/rtc1`" & \
printf "system clock is %s \n" "`hwclock -f /dev/rtc0 `"
sleep 2
echo "sleeping 10 seconds"
sleep 8
printf "after sleep our clock is %s \n" "`hwclock -f /dev/rtc1`" & \
printf "after sleep system clock is %s \n" "`hwclock -f /dev/rtc0 `"
sleep 1
echo " "

echo "going south"
echo "rand" > /proc/driver/rtcspeed
echo " "
echo "setting hwclock to current time"
hwclock -w -f /dev/rtc1 || (echo "set hwclock  failed"; exit 1)
echo "reading time"
printf "our clock is %s \n" "`hwclock -f /dev/rtc1`" & \
printf "system clock is %s \n" "`hwclock -f /dev/rtc0 `"
sleep 2
echo "sleeping 10 seconds"
sleep 8
printf "after sleep our clock is %s \n" "`hwclock -f /dev/rtc1`" & \
printf "after sleep system clock is %s \n" "`hwclock -f /dev/rtc0 `"
sleep 1
echo " "


exit 0


#!/bin/sh

die() { echo "$@" >&2 ; exit 1; }

if ps -fax | grep -v grep | grep ntpd ; then
  die "Please stop ntpd to measure the time reliably"
fi

if test `whoami` != "root" ; then
  die "The script is designed to be run as root"
fi

export LANG=C
T=/tmp/clockmon.txt
while true; do
  hwclock --verbose >$T
  NETTIME=`wget -q -O- time.nist.gov:13 | awk '{print $2,$3}' | grep -v "^ *$" | (read t; date +"%s" -d "$t +0000")`
  SYSTIME=`sed -n 's/System Time: \(.*\)/\1/pg' $T`
  HWTIME=`sed -n 's/Hw clock time [^=]\+= \([0-9.]*\).*/\1/pg' $T`
  echo "$NETTIME,$SYSTIME,$HWTIME" | tee -a /tmp/clockmon.log
  sleep 60
done

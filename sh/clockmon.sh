#!/bin/sh

die() { echo "$@" >&2 ; exit 1; }

if ps fax | grep -v grep | grep ntpd ; then
  die "Please stop ntpd to measure the time reliably"
fi

if test `whoami` != "root" ; then
  die "The script is designed to be run as root"
fi

export LANG=C
T=/tmp/clockmon.txt
O=/tmp/clockmon.log
echo >$O
while true; do
  hwclock --verbose >$T
  NETTIME=`wget -q -O- time.nist.gov:13 | awk '{print $2,$3}' | grep -v "^ *$" | (read t; date +"%s" -d "$t +0000")`
  SYSTIME=`sed -n 's/System Time: \(.*\)/\1/pg' $T`
  HWTIME=`sed -n 's/Hw clock time [^=]\+= \([0-9.]*\).*/\1/pg' $T`
  NSUSP=`dmesg |  grep 'suspend exit' | wc -l`
  echo "$NETTIME,$SYSTIME,$HWTIME,$NSUSP" | tee -a "$O"
  sleep 60
done

#!/usr/bin/env python3
import matplotlib.pyplot as plt

from os import system
from numpy import genfromtxt

# system("scp root@pf:/tmp/clockmon.log /tmp/clockmon-pinephone.log")

NET,SYS,RTC=0,1,2

def plotlogs(f,ax,t):
    x=genfromtxt(f,delimiter=',')
    ax.plot((x[:,NET]-x[0,NET])/60,x[:,NET]-x[:,SYS],'.',label='netclock-sysclock')
    ax.plot((x[:,NET]-x[0,NET])/60,x[:,NET]-x[:,RTC],'.',label='netclock-rtclock')
    ax.legend()
    ax.title.set_text(t)
    ax.grid()

f,(ax1,ax2)=plt.subplots(2,1,figsize=(6,8))
plotlogs('/tmp/clockmon.log',ax1,'Typical host PC, time delta, sec')
plotlogs('/tmp/clockmon-pinephone.log',ax2,'Pinephone, time delta, delta')
plt.subplots_adjust(hspace=0.4)
plt.show()


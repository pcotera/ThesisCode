#This code counts how many times people flushed the toilet. It calculates the difference
#between max and min distance value (per event) and uses a threshold of 0.39cm to define there was flushing

import math
import numpy as np
import pandas as pd

inFileName = input("Enter SD+number: ")
bc = pd.read_csv(inFileName+'Clean.csv', sep='[:,]', engine='python')
a = bc['Idx']
d = bc['DIST']

Pointer = 360  #start in zero if counting installation event. 
TotalEvents = 0
TotalFlush = 0
Threshold = 0.39


def CalcRange(NrSample):
    i=1
    FlushCount=0
    Pint=Pointer #Internal pointer so we don't mess with the global pointer
    
    while (i<=NrSample): #We check each block of 180s within the event. Most events only have one block. 
        Distance = d[Pint+1:Pint+180] #We disregard the first distance measurement because it's always off. 
        Range = abs(Distance.max()-Distance.min())
        if (Range > Threshold):
            isFlush = 1
            print(a[Pointer])
        else:
            isFlush = 0
        FlushCount=FlushCount+isFlush #we don't know in which block the flush happened. We need to count them. 
        Pint = Pint+180
        i+=1 
    if (FlushCount>0):
        FlushCount=1
    return FlushCount;

while (Pointer<(len(a)-360)): #change to 360 for SD01

    NrSample = 1
    while abs(a[Pointer+(180*NrSample)]-a[Pointer+(180*NrSample)-1]<40): #40 seconds threshold for discerning events
        NrSample += 1 

    Event = a[Pointer:Pointer+(180*NrSample)]
    TotalFlush = TotalFlush + CalcRange(NrSample)
    Pointer = Pointer + (180*NrSample)
    TotalEvents +=1 
    
Event = a[Pointer:Pointer+(180*NrSample)] 
TotalFlush = TotalFlush + CalcRange(NrSample)
Pointer = Pointer + (180*NrSample) 
TotalEvents +=1  

#Event.to_csv('Counter.csv')
#print(Pointer)
print('Total Events: ')
print(TotalEvents)
print('Total Flushes: ')
print(TotalFlush)





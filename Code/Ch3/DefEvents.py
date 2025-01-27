#This code counts defecation events. It calculates the difference
#between gas values (per event) and uses a treshold of (~80) to define there was a defecation event. 
#It ignores the first (60) gas measurements from each sample as well as the last measurement. 

import math
import numpy as np
import pandas as pd

inFileName = input("Enter SD+number: ")
bc = pd.read_csv(inFileName+'Clean.csv', sep='[:,]', engine='python')
a = bc['Idx']
g = bc['GAS']

Pointer = 360 #start in zero if counting installation event. 
TotalEvents = 0
TotalPoop = 0
GasOffset = 60 #between 60-80 recommended
GasThreshold = 79 #79 recommended

def CalcGas(NrSample):
    i=1
    PoopCount=0
    Pint=Pointer #Internal pointer so we don't mess with the global pointer
    
    while (i<=NrSample): #We check each block of 180s within the event. Most events only have one block. 
        GasVals = g[Pint+GasOffset:Pint+179] #We disregard the first 80 and the last measurement. 
        Range = abs(GasVals.max()-GasVals.min())
        if (Range > GasThreshold):
            isPoop = 1
            print(a[Pointer]) #for knowing when they pooped. 
        else:
            isPoop = 0
        PoopCount=PoopCount+isPoop #we don't know in which block the poop happened. We need to count them. 
        Pint = Pint+180
        i+=1 
    if (PoopCount>0):
        PoopCount=1
    return PoopCount;

while (Pointer<(len(a)-360)):  #change to 360 for SD01

    NrSample = 1
    while abs(a[Pointer+(180*NrSample)]-a[Pointer+(180*NrSample)-1]<40): #40 seconds threshold for discerning events
        NrSample += 1 

    Event = a[Pointer:Pointer+(180*NrSample)]
    TotalPoop = TotalPoop + CalcGas(NrSample)
    Pointer = Pointer + (180*NrSample)
    TotalEvents +=1 
    
Event = a[Pointer:Pointer+(180*NrSample)] 
TotalPoop = TotalPoop + CalcGas(NrSample)
Pointer = Pointer + (180*NrSample) 
TotalEvents +=1  

#Event.to_csv('Counter.csv')
#print(Pointer)
print('Total Events: ')
print(TotalEvents)
print('Total Defecations: ')
print(TotalPoop)





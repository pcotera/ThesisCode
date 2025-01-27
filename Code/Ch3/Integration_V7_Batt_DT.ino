/*
 * Integration V7 code for all the sensors. For the dry toilets in Toltenco Nov 13/2020
 * This code works with hardware version DAQ5. PIR, SHARP, GAS and TILT sensors.  
 * It saves data only with PIR==HIGH for 180 samples at least. if not it sleeps. 
 */

#include <Wire.h>
#include <SD.h>
#include <RTCZero.h>
#include "ArduinoLowPower.h"

const int gasEN = 12; //Digital out for enabling 5V to gas sensor
const int disEN = 11; //enabling 5v to distance sensor
const int pir = 9; //Din from PIR sensor 
const int gasPIN = A0; //Analog input from gas sensor
const int disPIN = A1; //Analog input from sharp distance sensor
const int tilt = A2; //Digital input from tilt sensor
const int resVals = 1024; //resolution for ADC, can be up to 4096

int avgReads[20] PROGMEM;
int sumReads = 0;
int avgValue = 0;
int gasValue = 0;   // Analog reading from gas sensor
bool pirValue = 0; 
bool tiltValue = 0; // Digital reading from tilt sensor
float sensorVolts = 0.0;
float distance = 0.0;   //Computed distance from sharp sensor
RTCZero rtc;
File myFile;

void setup() {
  pinMode(13, OUTPUT); 
  pinMode(gasEN, OUTPUT);
  pinMode(disEN, OUTPUT);
  pinMode(tilt, INPUT_PULLDOWN);
  pinMode(pir, INPUT_PULLDOWN); //Set to GND, wait for rising signal from pir
  LowPower.attachInterruptWakeup(pir, wakeUp, RISING); //FALLING or CHANGE
  rtc.begin();
  digitalWrite(13, LOW);
  digitalWrite(gasEN, LOW);
  digitalWrite(disEN, LOW);
}

void loop() {

  if (digitalRead(pir) == HIGH)
  {
    digitalWrite(13, HIGH);
    digitalWrite(gasEN, HIGH);
    digitalWrite(disEN, HIGH);
    
    if (!SD.begin(4)){ while (1);}
    myFile = SD.open("allsens.txt", FILE_WRITE);
    if (myFile) {  
      int cn = 1;
      while(cn <= 180){
        distSensing();                // get sharp sensor voltage filtered (averaged)
        gasSensing();
        pirValue = digitalRead(pir);  // read PIR state 
        tiltValue = digitalRead(tilt);
        myFile.print(rtc.getDay());
        myFile.print(":");
        myFile.print(rtc.getHours());
        myFile.print(":");
        myFile.print(rtc.getMinutes());
        myFile.print(":");
        myFile.print(rtc.getSeconds());
        myFile.print(", ");
        myFile.print(pirValue);
        myFile.print(", ");
        myFile.print(tiltValue);
        myFile.print(", ");
        myFile.print(gasValue);
        myFile.print(", ");
        myFile.println(distance, 2);
        LowPower.sleep(500);
        cn++;
      }  
        myFile.close();
    }
  }
  else 
  {
    digitalWrite(13, LOW);
    digitalWrite(gasEN, LOW);
    digitalWrite(disEN, LOW);
    LowPower.sleep();
  }
}

void wakeUp() {;}

void distSensing(){                                    
  for (int i=0; i<20; i++){             //read 20 samples from analog input
    avgReads[i] = analogRead(disPIN); 
    delay(25);
  }
  sumReads = 0;                         //get the average
  for (int i=0; i<20; i++){
    sumReads = sumReads + avgReads[i];
  }
    avgValue = sumReads / 20;
    sensorVolts = avgValue*3.3/resVals; 
    distance = pow(sensorVolts, -1.07);
    distance *= 11.96;
}

void gasSensing(){
  gasValue = analogRead(gasPIN);
}

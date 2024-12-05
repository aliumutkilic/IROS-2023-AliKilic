#include <Arduino.h>
#include <Encoder.h>
#include <SD.h>
#include <SPI.h>

// Variables
File myFile;
int myVar1;
int myVar2;
int myVar3;
int myVar4;
int i = 0;
float a;
const int chipSelect = BUILTIN_SDCARD;
float current_timer;
float desired_pos;
float encoder_pulses;
float encoder_position;
float error_now;
float control_current;
float max_current = 3;
float duty_cycle;
boolean direction;
int direction_pin=1;
int pwm_pin=3;
float time1;
float previous_error_signal;
float previous_control_signal;
int ppr = 1273;
float pi =  3.14;
// float coeff1 = 0.8544;
// float coeff2 = 10.28;
// float coeff3 =  -9.845;
float coeff1 = 0.8544;
float coeff2 = 77.82;
float coeff3 =  -77.09;

int enable_pin=0;
float current_reading;

float x;


int counter = 1;
int counter2 = 1;
float modulation_signal;
float modified_frequency;
float modulation_frequency = 0.1;


// Create a union to easily convert float to byte
typedef union{
  float number;
  uint8_t bytes[4];
} FLOATUNION_t;

FLOATUNION_t myValue;
FLOATUNION_t myValue2;
FLOATUNION_t myValue3;
FLOATUNION_t myValue4;
Encoder enc_read(33, 34);

IntervalTimer myTimer;


void motor_control() {



current_timer = millis();                              //Measured Time in Milliseconds




    float fvalue = myFile.parseFloat();
    //Serial.print("Found float value ");
    a = fvalue;

desired_pos = a*PI/180;


encoder_pulses = enc_read.read();                      //Pulses measured

// Convert Pulses to Radins


encoder_position = encoder_pulses/(4*ppr);
encoder_position *= 2*pi;


// Calculate the Error

error_now = desired_pos - encoder_position;


// Calculate the Control Signal

control_current = coeff1*previous_control_signal +coeff2*error_now +  coeff3*previous_error_signal;


//  Saturation

if(control_current>=max_current){

  control_current = max_current;

}
else if(control_current <= -1*max_current){

  control_current = -max_current;

}

//  Direction control
 
if(control_current > 0){

    direction= 0;

  }
else{

  direction = 1;

}

  

// Compute Duty Cycle

//duty_cycle = (control_current+max_current)/(2*max_current);
duty_cycle = abs(control_current+max_current)/(2*max_current);
if(duty_cycle >= 0.9){

  duty_cycle = 0.9;
}
else if (duty_cycle <=0.1){
  duty_cycle = 0.1;
}
//digitalWrite(direction_pin,direction);


//Send the current and direction  

analogWrite(pwm_pin,512*duty_cycle);

// Update the previous values

previous_error_signal = error_now;
previous_control_signal = control_current;


// Prinout
current_reading = analogRead(A0);
current_reading = map(current_reading,0,1023,-max_current,max_current);
//current_reading -= 1023;
//current_reading /= 1023;
//current_reading *= 2*max_current;
time1 = millis();
//Serial.println(a);

Serial.write('A'); 
   for (int i=0; i<4; i++){
    Serial.write(myValue.bytes[i]); 
  }
     for (int i=0; i<4; i++){
    Serial.write(myValue2.bytes[i]); 
  }

       for (int i=0; i<4; i++){
    Serial.write(myValue3.bytes[i]); 
  }

         for (int i=0; i<4; i++){
    Serial.write(myValue4.bytes[i]); 
  }
  // Print terminator
  Serial.print('\n');

}



void setup() {
  
  digitalWrite(enable_pin,1);
analogWriteResolution(9);
//analogWriteFrequency(pwm_pin,5000);
// Print Frequency
 Serial.begin(38400);
   while (!Serial) {
     // wait for serial port to connect.
  }


  Serial.print("Initializing SD card...");

  if (!SD.begin(chipSelect)) {
    Serial.println("initialization failed!");
    return;
  }
  Serial.println("initialization done.");
  
  myFile = SD.open("test.txt");
// Set pin modes
 /*
pinMode(direction_pin,OUTPUT);
pinMode(pwm_pin,OUTPUT);
pinMode(enable_pin,OUTPUT);

// Enable ESCON
digitalWrite(enable_pin,HIGH);
*/
// Start the 1khz control loop
myTimer.begin(motor_control, 1000);

}

void loop() {
  myValue3.number = desired_pos*180/pi;
myValue2.number = encoder_position*180/pi;
myValue.number = current_reading;
myValue4.number = time1/1000;
//  Serial.write('A'); 

//    for (int i=0; i<4; i++){
//     Serial.write(myValue.bytes[i]); 
//   }
//   // Print terminator
//   Serial.print('\n');
//   delay(1);  
}


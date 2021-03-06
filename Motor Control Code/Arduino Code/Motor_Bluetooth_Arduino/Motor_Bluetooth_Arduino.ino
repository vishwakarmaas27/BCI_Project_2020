/*
Code to move motor 
  In anticlockwise direction if 'a' is send to the bluetooth.
  In clockwise direction if 'c' is sent to the bluetooth.
  And stop motor if 'o' is sent to the bluetooth.

Hardware Used: L293D Motor Drive along with 2 Motors and Bluetooth module to receive Commands.

Author : Shivam Vishwakarma
*/
//L293D
//Motor A
const int motorPin1  = 9;  // Pin 14 of L293D  / IN4
const int motorPin2  = 10;  // Pin 10 of L293D / IN3
//Motor B
const int motorPin3  = 12; // Pin  7 of L293D  / IN2
const int motorPin4  = 11;  // Pin  2 of L293D  / IN1

char junk;
String inputString="";

void setup()                    // run once, when the sketch starts
{
 Serial.begin(9600);            // set the baud rate to 9600, same should be of your Serial Monitor
}

void loop()
{
  if(Serial.available()){
  while(Serial.available())
    {
      char inChar = (char)Serial.read(); //read the input
      inputString += inChar;        //make a string of the characters coming on serial
    }
    
    Serial.println(inputString);
    while (Serial.available() > 0)  
    { junk = Serial.read() ; }      // clear the serial buffer
    
    if(inputString == "c")
    {         
    digitalWrite(motorPin1, HIGH);
    digitalWrite(motorPin2, LOW);
    digitalWrite(motorPin3, HIGH);
    digitalWrite(motorPin4, LOW);
    }
    else if(inputString == "a")
    {  
    digitalWrite(motorPin1, LOW);
    digitalWrite(motorPin2, HIGH);
    digitalWrite(motorPin3, LOW);
    digitalWrite(motorPin4, HIGH);
    }
    else if(inputString == "o")
    {  
    digitalWrite(motorPin1, LOW);
    digitalWrite(motorPin2, LOW);
    digitalWrite(motorPin3, LOW);
    digitalWrite(motorPin4, LOW);
    }
    inputString = "";
  }
}

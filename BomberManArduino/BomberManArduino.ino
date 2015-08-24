const int redPin    = 12;
const int bluePin   = 11;
const int greenPin  = 10;
const int yellowPin = 9;

const int bomb      = 3;

const int buzzer    = 6;


void setup() 
{
  Serial.begin(9600);
  
  pinMode(redPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(yellowPin, OUTPUT);
  pinMode(bomb, INPUT);
}

void loop() 
{
  
  
  
  int val = digitalRead(bomb);
  
  if (val == HIGH) 
  {
    Serial.print('B');
  }
  
  
  if (Serial.available() > 0) 
  {   
    
    byte processingVal = Serial.read();
    
    if ( processingVal == 'U' ) 
    {
      digitalWrite(redPin, HIGH);
      digitalWrite(bluePin, LOW);
      digitalWrite(greenPin, LOW);
      digitalWrite(yellowPin, LOW);
    } 
    else if ( processingVal == 'L' )
    {
      digitalWrite(redPin, LOW);
      digitalWrite(bluePin, HIGH);
      digitalWrite(greenPin, LOW);
      digitalWrite(yellowPin, LOW);
    } 
    else if ( processingVal == 'R' )
    {
      digitalWrite(redPin, LOW);
      digitalWrite(bluePin, LOW);
      digitalWrite(greenPin, HIGH);
      digitalWrite(yellowPin, LOW);
    }
    else if ( processingVal == 'D' )
    {
      digitalWrite(redPin, LOW);
      digitalWrite(bluePin, LOW);
      digitalWrite(greenPin, LOW);
      digitalWrite(yellowPin, HIGH);
    }
      
    
    if ( processingVal == 'S' ) 
    {
      digitalWrite(buzzer, HIGH);
      delayMicroseconds(1700);
      digitalWrite(buzzer, LOW);
      delayMicroseconds(1700);
    }
    
    
    delay(100);
  }

}


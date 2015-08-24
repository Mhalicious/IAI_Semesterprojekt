import java.util.Map;
import java.util.Iterator;
import SimpleOpenNI.*;

import ddf.minim.*;
import processing.serial.*;

SimpleOpenNI kinect;

Minim minim;
AudioSnippet bg;

Serial myPort;
String arduinoVal;

final int FULL_WIDTH = 800;
final int WINDOW_WIDTH = 400, 
WINDOW_HEIGHT = 400, 
TILE_SIZE = 28, 
FRAME_RATE = 30, 
EXPLODE_R = 3;
int playX = 150;
int playY = 100;
int rectX = 100;
int rectY = 50;


boolean showControls = false;
int controlLength   = 70;
int hControlLength  = controlLength / 2;
int controlsPadding = 25;

// Berechnungen für Controls
float upDownControlXPos    = WINDOW_WIDTH + (WINDOW_WIDTH/2) - hControlLength;
float upControlYPos        = controlsPadding;
float leftRightControlYPos = (WINDOW_HEIGHT/2) - hControlLength;
float leftControlXPos      = WINDOW_WIDTH + controlsPadding;
float rightControlXPos     = FULL_WIDTH - controlLength - controlsPadding;
float downControlYPos      = WINDOW_HEIGHT - controlLength - controlsPadding;

int lastMoved    = 0;
int moveWaitTime = 500; // ms


Field map = new Field(WINDOW_WIDTH, WINDOW_HEIGHT);
Player dau1 = new Player(map, 0, 0, "Matthias");
Player dau2 = new Player(map, 12, 12, "Klaus");


void setup() 
{
  size(FULL_WIDTH, WINDOW_HEIGHT);
  
  //Kinect Setup
  kinect = new SimpleOpenNI(this);
  if(kinect.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  // enable depthMap generation 
  kinect.enableDepth();
  
  // disable mirror
  kinect.setMirror(true);
  //Grunfarbe 3D Depth Map
  kinect.setDepthImageColor(35, 110, 27);

  // enable hands + gesture generation
  
  kinect.enableHand();
  
  //Enable Hand geht nur mit Gesture
  kinect.startGesture(SimpleOpenNI.GESTURE_HAND_RAISE);
  
  
  smooth();
  wall=loadImage("wall.png");
  boom=loadImage("boom.png");
  bomb=loadImage("bomb.png");
  block=loadImage("block.png");

//  minim = new Minim(this);
//  bg = minim.loadSnippet("bomberman.mp3");
//  bg.play();

  // println(Serial.list());
  
  
  myPort = new Serial(this, "/dev/tty.usbmodem1421", 9600);
}



void keyPressed() {

  switch(key) {

    //Steuerung Spieler 1  
  case 'j':
    dau1.moveLeft();
    break;        

  case 'l':
    dau1.moveRight();
    break; 

  case 'i':
    dau1.moveUp();
    break;  

  case 'k':
    dau1.moveDown(); 
    break;

  case 'o':
    dau1.setBomb();
    break;        
    //Steuerung Spieler 2
  case 'a':
    dau2.moveLeft();
    break;        

  case 'd':
    dau2.moveRight();
    break; 

  case 'w':
    dau2.moveUp();
    break;  

  case 's':
    dau2.moveDown(); 
    break;

  case ' ':
    dau2.setBomb();
    break;     



   default : break;
  }
}


void draw() 
{
  // update the cam
  kinect.update();
 
  dau1.checkBombAndPlayer();
  dau2.checkBombAndPlayer();
  

  background(#696969);
  
  //Kinect Bild wird gezeichnet
  image(kinect.depthImage(),400,0);
  
  fill(0, 255, 255, 200);
  
  //Controlls anzeigen wenn Hand erkannt wird
  if (showControls) 
  {
    // up
    rect(upDownControlXPos, upControlYPos, controlLength, controlLength);
    // left
    rect(leftControlXPos, leftRightControlYPos, controlLength, controlLength);
    // right
    rect(rightControlXPos, leftRightControlYPos, controlLength, controlLength);
    // down
    rect(upDownControlXPos, downControlYPos, controlLength, controlLength);
  }
  
  map.display();
}

// Neue Hand erkennen

void onNewHand(SimpleOpenNI curContext,int handId,PVector pos)
{
  //println("onNewHand - handId: " + handId + ", pos: " + pos);
 
  //Wenn Hand erkannt wird - werden Controller Buttons angezeigt
  showControls = true;
}

void onCompletedGesture (SimpleOpenNI kinect, int gestureType, PVector pos)
{
  //println("type: " + gestureType + ", pos: " + pos);
  int handId = kinect.startTrackingHand(pos);
}

void onTrackedHand (SimpleOpenNI context, int handId, PVector pos)
{
  //println("pos: " + pos);
  
  // Make the Real world coordinates happen ;)
  PVector handPos = new PVector(); 
  context.convertRealWorldToProjective(pos, handPos);
  
  //println("handPos: " + handPos);
  //println("x: " + handPos.x + "y: " + handPos.y + "z: " + handPos.z);
  
  
  int now = millis();
  int canMoveAfter = lastMoved + moveWaitTime;
  
  if ( canMoveAfter <= now )
  {
    float handPosX = handPos.x + WINDOW_WIDTH + 10;
    float handPosY = handPos.y;
    
    // up
    boolean isUp    = ( handPosX > upDownControlXPos && handPosX < upDownControlXPos + controlLength &&
                        handPosY > upControlYPos     && handPosY < upControlYPos     + controlLength );
                        
    boolean isLeft  = ( handPosX > leftControlXPos      && handPosX < leftControlXPos      + controlLength &&
                        handPosY > leftRightControlYPos && handPosY < leftRightControlYPos + controlLength);
                        
    boolean isRight = ( handPosX > rightControlXPos     && handPosX < rightControlXPos      + controlLength &&
                        handPosY > leftRightControlYPos && handPosY < leftRightControlYPos  + controlLength);
    
    boolean isDown  = ( handPosX > upDownControlXPos && handPosX < upDownControlXPos + controlLength &&
                        handPosY > downControlYPos   && handPosY < downControlYPos   + controlLength );
    
    if ( isUp || isLeft || isRight || isDown )
    {
      if ( isUp ) 
      {
        dau1.moveUp();
        myPort.write('U'); 
      }
      else if ( isLeft )
      {
        dau1.moveLeft();
        myPort.write('L'); 
      }
      else if ( isRight )
      {
        dau1.moveRight();
        myPort.write('R'); 
      }
      else if ( isDown )
      {
        dau1.moveDown();
        myPort.write('D'); 
      }
      
      lastMoved = millis();
    }  
  }
    

  // remember to show the control field
  showControls = true;
}


/** 
 * as soon as hand is lost
 */
void onLostHand (SimpleOpenNI context, int handId)
{
  // remember to hide the control field
  showControls = false;
}


void serialEvent(Serial myPort) 
{
  int inByte = myPort.read();
  
  if (inByte == 'B') 
  {
      dau1.setBomb();
    
      myPort.clear();
  }
}




class Bomb {
  float timer, timeStart, timerEnd;
  boolean explode, operating;
  int positionX, positionY, explodeRadius;
  Field area;

  Bomb(Field f) {
    area = f;
    operating = false;
  }

  void setBomb(int x, int y, int z, float t) {
    positionX = x;
    positionY = y;
    explodeRadius = z;
    timerEnd = t;
    area.box[positionX][positionY].setBomb();
    operating = true;
    timeStart = (float)frameCount / FRAME_RATE;    
  }

  void checkExplode() {
    timer = (float)frameCount / FRAME_RATE - timeStart;

    if(timer >= timerEnd)
      explode();
  }

  void explode() {

    //nach rechts
    if( positionX+1 < area.tilesX) { 
      if( area.box[positionX+1][positionY].getType() != "blocked" ) {
        for( int x = positionX; x <= positionX + explodeRadius; x++ ) {
          if( x < area.tilesX ) {     
            if( area.box[x][positionY].getType() == "wall" ) {
              area.box[x][positionY].setType("explode");  
              break;
            } 
            else
              area.box[x][positionY].setType("explode");
          }
        }
      }
    }

    //nach links
    if( positionX-1 >= 0) {
      if( area.box[positionX-1][positionY].getType() != "blocked" ) {
        for( int x = positionX; x >= positionX - explodeRadius; x-- ) {   
          if( x >= 0 ) {
            if( area.box[x][positionY].getType() == "wall" ) {
              area.box[x][positionY].setType("explode");  
              break;
            } 
            else
              area.box[x][positionY].setType("explode");
          }
        }
      }
    }

    //nach unten
    if( positionY+1 < area.tilesY ) {
      if( area.box[positionX][positionY+1].getType() != "blocked" ) {
        for( int y = positionY; y <= positionY + explodeRadius; y++ ) {   
          if( y < area.tilesY ) {
            if( area.box[positionX][y].getType() == "wall" ) {
              area.box[positionX][y].setType("explode");  
              break;
            } 
            else
              area.box[positionX][y].setType("explode");
          }
        }
      }
    }
    
    //nach oben
    if( positionY-1 >= 0) {
      if( area.box[positionX][positionY-1].getType() != "blocked" ) {
        for( int y = positionY; y >= positionY - explodeRadius; y-- ) {   
          if( y >= 0 ) {
            if( area.box[positionX][y].getType() == "wall" ) {
              area.box[positionX][y].setType("explode");  
              break;
            } 
            else
              area.box[positionX][y].setType("explode");
          }
        }
      }
    }


    area.box[positionX][positionY].delBomb();
    operating = false;
    timer = 0;
    
    myPort.write('S');

  }

  boolean isWorking() {
    return operating;
  }

}














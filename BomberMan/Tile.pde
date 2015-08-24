PImage boom;
PImage bomb;
PImage block;



class Tile {
  String type;
  boolean usedByPlayer, bombed, exploding;
  int frameCounter;

Tile()
{
  
}
  Tile (String t) {
    type = t;
    bombed = false;
    exploding = false;
    usedByPlayer = false;
  }

  void display(int x, int y) {
    fill(#236e1b);
    rect(x, y, TILE_SIZE, TILE_SIZE);

    if (type == "wall") {
      block.resize(25, 25);
      image(block, x+2, y+2);
      //fill(#865D09);
      //rect( x+3, y+3, TILE_SIZE-6, TILE_SIZE-6);
    }    

    if (type == "Matthias") {
      fill(#0D27B7);
      ellipse( x+TILE_SIZE/2, y+TILE_SIZE/2, TILE_SIZE*3/4, TILE_SIZE*3/4 );
    }

    if (type == "Klaus") {
      fill(#FF0000);
      ellipse( x+TILE_SIZE/2, y+TILE_SIZE/2, TILE_SIZE*3/4, TILE_SIZE*3/4 );
    }


    if (type == "explode") {       
      if (!exploding) {
        exploding = true;
        frameCounter = 0;
      }
      frameCounter++;
      if ( frameCounter/FRAME_RATE == 1 ) {
        type = "free";
        exploding = false;
      } 
      else {
        boom.resize(20, 20);
        image(boom, x+5, y+5);
      }
    }

    if (bombed) {
      bomb.resize(20, 20);
      image(bomb, x+5, y+5);
      //fill(0);
      //ellipse( x+TILE_SIZE/2, y+TILE_SIZE/2, TILE_SIZE*1/2, TILE_SIZE*1/2);
    }
  }

  String getType() {
    return type;
  }

  void setType(String t) {
    type = t;
  }

  void setBomb() {
    bombed = true;
  }

  void delBomb() {
    bombed = false;
  }

  void setPlayer() {
    usedByPlayer = true;
  }

  void delPlayer() {
    usedByPlayer = false;
  }

  boolean usable() {
    if ( type != "wall" && !usedByPlayer) 
      return true;

    else
      return false;
  }
}


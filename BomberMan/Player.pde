

class Player {
  //pp = playerPosition
  int ppX, ppY;
  String name;
  boolean dead= false;

  Field area;
  Bomb bomb;
  Tile tile = new Tile();


  Player(Field f, int x, int y, String n) {
    area = f;
    bomb = new Bomb(area);
    ppX = x;
    ppY = y;
    name = n;
    area.box[ppX][ppY].setType(name);
    if ( ppX+1 < area.tilesX ) 
      area.box[ppX+1][ppY].setType("free");
    if ( ppX-1 >= 0 ) 
      area.box[ppX-1][ppY].setType("free");
    if ( ppY+1 < area.tilesY ) 
      area.box[ppX][ppY+1].setType("free");
    if ( ppY-1 >= 0 )
      area.box[ppX][ppY-1].setType("free");
  }

  void moveLeft() {      
    if ( ppX - 1 >= 0 && area.box[ppX-1][ppY].usable() ) {
      area.box[ppX][ppY].setType("free");
      area.box[ppX][ppY].delPlayer();
      ppX--;
      checkKilled(ppX, ppY);
      area.box[ppX][ppY].setType(name);
      area.box[ppX][ppY].setPlayer();
    }
  }

  void moveRight() {      
    if ( ppX + 1 < area.tilesX && area.box[ppX+1][ppY].usable() ) {
      area.box[ppX][ppY].setType("free");
      area.box[ppX][ppY].delPlayer();
      ppX++;
      checkKilled(ppX, ppY);
      area.box[ppX][ppY].setType(name);
      area.box[ppX][ppY].setPlayer();
    }
  }

  void moveUp() {     
    if ( ppY - 1 >= 0 && area.box[ppX][ppY-1].usable() ) {
      area.box[ppX][ppY].setType("free");
      area.box[ppX][ppY].delPlayer();
      ppY--;
      checkKilled(ppX, ppY);
      area.box[ppX][ppY].setType(name);
      area.box[ppX][ppY].setPlayer();
    }
  }

  void moveDown() {  

    if ( ppY + 1 < area.tilesY && area.box[ppX][ppY+1].usable() ) {
      area.box[ppX][ppY].setType("free");
      area.box[ppX][ppY].delPlayer();
      ppY++;
      checkKilled(ppX, ppY);
      area.box[ppX][ppY].setType(name);
      area.box[ppX][ppY].setPlayer();
    }
  }

  void setBomb() {
    if (! bomb.isWorking() ) {
      bomb.setBomb( ppX, ppY, EXPLODE_R, 3);
    }
  }

  void checkBombAndPlayer() {
    if ( area.box[ppX][ppY].getType() == "explode" )
      
      killed();
    if ( bomb.isWorking() )
      bomb.checkExplode();
  }

  void checkKilled(int x, int y) {
    if ( area.box[x][y].getType() == "explode"  )

      killed();
  }

  void killed() {
    println( name + " killed!");
    Object[] options = {
      "Quit", 
    };

    int n = javax.swing.JOptionPane.showOptionDialog(frame, name + " is dead as fuck!!", 
    "GAME OVER", 
    javax.swing.JOptionPane.OK_OPTION, 
    javax.swing.JOptionPane.QUESTION_MESSAGE, 
    null, //do not use a custom Icon
    options, //the titles of buttons
    options[0]); //default button title

    noLoop();


    if ( n == javax.swing.JOptionPane.OK_OPTION)
      exit();
      
     
   
  }
}


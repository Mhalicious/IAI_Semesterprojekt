 PImage wall;
 
class BlockedTile extends Tile {

  BlockedTile() {
    super("blocked");
  }

  void display(int x, int y) {
        wall.resize(28,28);
        image(wall,x+1, y+1);
    //fill(0);
    //rect(x, y, TILE_SIZE, TILE_SIZE);
  }

  String getType() {
    return "blocked";
  }

  boolean usable() {
    return false;
  }
}





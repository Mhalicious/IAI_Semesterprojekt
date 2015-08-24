class Field {
  int width, height, stdX, stdY,
  tilesX, tilesY;

  Tile[][] box;

  Field(int a, int b) {
    width = a;
    height = b;

    tilesX = a/TILE_SIZE;
    if(tilesX%2 == 0) {
      tilesX--;
      stdX = (WINDOW_WIDTH - tilesX * TILE_SIZE) / 2;
    }

    tilesY = b/TILE_SIZE;
    if(tilesY%2 == 0) {
      tilesY--;
      stdY = (WINDOW_HEIGHT - tilesY * TILE_SIZE) / 2;
    }

    box = new Tile[tilesX][tilesY];
    for( int i = 0; i < tilesX; i++ ) {
      for( int j = 0; j < tilesY; j++ ) {
        if( (i+1)%2 == 0 && (j+1)%2 == 0) 
          box[i][j] = new BlockedTile();
        else if (  (i+1)%2 == 0 || (j+1)%2 == 0 ) 
          box[i][j] = new Tile("wall");
        else
          box[i][j] = new Tile("free");
      }
    }
  }

  void display() {
    for( int i = 0; i < tilesX; i++ ) {
      for( int j = 0; j < tilesY; j++ ) {
        box[i][j].display( stdX + i*TILE_SIZE, stdY + j*TILE_SIZE );
      }
    }
  }

  String getTileContent(int x, int y) {
    return box[x][y].getType();
  }

  void setTileContent(int x, int y, String t) {
    box[x][y].setType(t);
  }

}



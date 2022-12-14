class Block {
  /**
   * The coordinate x of its position.
   */ 
  int x;
  
  /**
   * The coordinate y of its position.
   */
  int y;

  /**
   * The row of the block.
   */
  int thisRow;

  /**
   * The column of the block.
   */
  int thisCol;

  /**
   * Array used to define each wall of the block.
   */
  boolean[] walls = {true, true, true, true};

  /**
   * Define f it's been visited already.
   */
  boolean visitedByMaze = false;

  /**
   * List of all neighbours block of a block.
   */
  ArrayList<Block> neighbors = new ArrayList<Block>();

  /**
   * 
   */
  boolean visitedBySearchAlgo = false;
  ArrayList<Block> mazeNeighbors = new ArrayList<Block>();
  float g = 10000000000.0;
  float f = 10000000000.0;
  float h;
  Block prev;

  Block(int row, int col) {
    x = row * size;
    y = col * size;
    thisRow = row;
    thisCol = col;
  }

  void show() {
    if (walls[0]) { //draw top line
      line(x, y, x + size, y);
    }
    if (walls[1]) { //draw right line
      line(x + size, y, x + size, y + size);
    }
    if (walls[2]) { //draw bottom line
      line(x + size, y + size, x, y + size);
    }
    if (walls[3]) { //draw left line
      line(x, y + size, x, y);
    }
    if (visitedByMaze && !isMazeFinished) {
      noStroke();
      fill(255, 50, 255, 95);
      //fill(0, 255, 255);
      rect(x, y, size, size);
      stroke(0);
    }
  }

  void addMazeNeighbors() {
    if (!walls[3]) { //we are not in top row. Add top neighbor.

      mazeNeighbors.add(blocks[thisRow - 1][thisCol]); //top neighbor
    }
    if (!walls[2]) { //we are not in rightmost column. Add right column.
      mazeNeighbors.add(blocks[thisRow][thisCol + 1]); //right neighbor
    }
    if (!walls[1]) { //we are not in bottom row. Add bottom neighbor.
      mazeNeighbors.add(blocks[thisRow + 1][thisCol]); //bottom neighbor
    }
    if (!walls[0]) { //we are not in leftmost column. Add left column.
      mazeNeighbors.add(blocks[thisRow][thisCol - 1]); //right neighbor
    }
  };

  void addNeighbors() {
    if (thisRow > 0) { //we are not in top row. Add top neighbor.
      neighbors.add(blocks[thisRow - 1][thisCol]); //top neighbor
    }
    if (thisCol < cols - 1) { //we are not in rightmost column. Add right column.
      neighbors.add(blocks[thisRow][thisCol + 1]); //right neighbor
    }
    if (thisRow < rows - 1) { //we are not in bottom row. Add bottom neighbor.
      neighbors.add(blocks[thisRow + 1][thisCol]); //bottom neighbor
    }
    if (thisCol > 0) { //we are not in leftmost column. Add left column.
      neighbors.add(blocks[thisRow][thisCol - 1]); //right neighbor
    }
  };

  boolean hasUnvisitedNeightbors() {
    for (Block neighbor : neighbors) {
      if (!neighbor.visitedByMaze) {
        return true;
      }
    }
    return false;
  }

  Block pickRandomNeighbor() {
    Block ngbr = neighbors.get(floor(random(0, neighbors.size())));
    while (ngbr.visitedByMaze) {
      neighbors.remove(ngbr);
      ngbr = neighbors.get(floor(random(0, neighbors.size())));
    }
    ngbr.visitedByMaze = true;
    neighbors.remove(ngbr);
    return ngbr;
  }

  void makeRect(int r, int g, int b) {
    noStroke();
    fill(r, g, b);
    rect(x, y, size, size);
    stroke(0);
  }
  
  void makeLine(Block to, int r, int g, int b) {
    strokeWeight(7);
    stroke(r, g, b);
    int x1 = x + size / 2;
    int y1 = y + size / 2;
    int x2 = to.x + size / 2;
    int y2 = to.y + size / 2;
    line (x1, y1, x2, y2);
    strokeWeight(4);
    stroke(0);
  }  
}
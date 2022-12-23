public class Block {
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
  ArrayList<Block> mazeNeighbors = new ArrayList<Block>();
  /**
   * 
   */
  boolean visitedBySearchAlgo = false;
  float g = 10000000000.0;
  float f = 10000000000.0;
  float h;
  Block prev;

  /**
   * Istantiate a block
   * @param row the position in the rows of the grid.
   * @param col the position in the columns of the grid.
   */
  Block(int row, int col) {
    x = row * sizeX;
    y = col * sizeY;
    thisRow = row;
    thisCol = col;
  }

  /**
   * Shows each wall of all blocks.
   */
  void show() {
    if (walls[0]) { //draw top line
      line(x, y, x + sizeX, y);
    }
    if (walls[1]) { //draw right line
      line(x + sizeX, y, x + sizeX, y + sizeY);
    }
    if (walls[2]) { //draw bottom line
      line(x + sizeX, y + sizeY, x, y + sizeY);
    }
    if (walls[3]) { //draw left line
      line(x, y + Y, x, y);
    }
    if (visitedByMaze && !isMazeFinished) {
      noStroke();
      fill(255, 50, 255, 95);
      rect(x, y, sizeX, sizeY);
      stroke(0);
    }
  }

  /**
   * Adds for every block its neighbours.
   */
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

  /**
   * Adds a neighbour for every row and colum in the maze.
   */
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

  /**
   * returns false if there are block without neighbours.
   */
  boolean hasUnvisitedNeightbors() {
    for (Block neighbor : neighbors) {
      if (!neighbor.visitedByMaze) {
        return true;
      }
    }
    return false;
  }

  /**
   * Picks a random neighbour block.
   */
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
 String toString(){
   return "Block{col:" + thisCol + " row:" + thisRow +"}";
 }
}

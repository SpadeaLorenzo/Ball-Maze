/**
 * Number of colums of the maze.
 */
int cols;

/**
 *Number of rows of the maze.
 */
int rows;

/**
 * size of the space between the walls of the maze.
 */
int size =  60;

/**
 * Array of blocks.
 */
Block[][] blocks;

/**
 * The current position of the block in the grid of the maze.
 */
Block currentMazeBlock;

/**
 * List of block used to keep track of the blocks in the maze.
 */
ArrayList<Block> mazeStack = new ArrayList<Block>();

/**
 * Flag to define if the generation of the maze is done.
 */
boolean isMazeFinished = false;

/**
 * Position of the current bolck of search in the maze.
 */
Block currentSearchBlock;

/**
 * Block where to start searching for the end
 */
Block startSearchBlock;

/**
 * Finish line block for the algorithm to find.
 */
Block finishSearchBlock;

/**
 * The perfect path to solve the maze.
 */
ArrayList<Block> actualPath = new ArrayList<Block>();

/**
 * The actual path the alorithm went through to find the perfect path.
 */
ArrayList<Block> searchedPath = new ArrayList<Block>();

/**
 * Flag to define if the searching algorithm has already passed that spot.
 */
boolean searchNeighborsAdded = false;

Player p;

PGraphics mz;



/**
 * Sets all the variables before the loop starts.
 * Defines the window size.
 */
void setup() {
  size(600, 600);
  rows = floor(height / size);
  cols = floor(width / size);
  blocks = new Block[rows][cols];
  p = new Player();
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      blocks[i][j] = new Block(i, j);
    }
  }

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      blocks[i][j].addNeighbors();
    }
  }

  currentMazeBlock = blocks[0][0];
  currentMazeBlock.visitedByMaze = true;
  mz = createGraphics(60, 60);
  frameRate(100);
  smooth();
}

public void mazeGenerator() {

  while (!isMazeFinished) { //Maze Generator Here
    fill(193, 50, 193);
    rect(currentMazeBlock.x, currentMazeBlock.y, size, size);
    if (currentMazeBlock.hasUnvisitedNeightbors()) {
      Block nextCurrent = currentMazeBlock.pickRandomNeighbor();
      mazeStack.add(currentMazeBlock);
      removeWalls(currentMazeBlock, nextCurrent);
      currentMazeBlock = nextCurrent;
    } else if (mazeStack.size() > 0) {
      Block nextCurrent = mazeStack.get(mazeStack.size() - 1);
      mazeStack.remove(nextCurrent);
      currentMazeBlock = nextCurrent;
    } else {
      isMazeFinished = true;
    }
  }
  mz.beginDraw();
  background(0, 255, 255);
  strokeWeight(4);
  stroke(255, 255, 0);
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      blocks[i][j].show();
    }
  }
  mz.endDraw();
}


void draw() {
  mazeGenerator();
  p.show();

  if (p.playerX >= 0 && p.playerX <= 600   && p.playerY >= 0 && p.playerY <= 600   ) {
    //posizione del player nella griglia
    int blockposx = floor(p.playerX/size);
    int blockposy = floor(p.playerY/size);
    print("X blocco:      " + blockposx + "    ");
    print("Y blocco:      " + blockposy + "    ");

    println("X : " + p.playerX);
    println("Y : " + p.playerY);

    //println(blocks[blockposx][blockposy].toString());


    p.allowL = !blocks[blockposx][blockposy].walls[3];
    println("LEFT : "  + p.allowL);

    p.allowR = !blocks[blockposx][blockposy].walls[1];
    println("RIGHT: "  + p.allowR);

    p.allowD = !blocks[blockposx][blockposy].walls[2];
    println("DOWN: "  + p.allowD);

    p.allowU = !blocks[blockposx][blockposy].walls[0];
    println("UP: "  + p.allowU);
    
    if(p.playerX >= size * blockposx && p.playerX <= blockposx * size + p.side && p.allowD && p.allowR){
     //
    }
    
    if(p.playerY >= size * blockposy && p.playerY <= blockposy * size + p.side && p.allowD && p.allowU){
    //
    }
     p.move();








    // riposiziona dentro i bordi
    if (p.playerX > 600 -p.side) {
      p.playerX = 600-p.side;
    }
    if (p.playerY > 600 -p.side) {
      p.playerY = 600-p.side;
    }
    if (p.playerX < 0 ) {
      p.playerX = 0;
    }
    if (p.playerY < 0 ) {
      p.playerY = 0;
    }
  }
}



void removeWalls(Block current, Block next) {
  int xDistance = current.thisRow - next.thisRow;
  int yDistance = current.thisCol - next.thisCol;

  if (xDistance == -1) {
    current.walls[1] = false;
    next.walls[3] = false;
  } else if (xDistance == 1) {
    current.walls[3] = false;
    next.walls[1] = false;
  }

  if (yDistance == -1) {
    current.walls[2] = false;
    next.walls[0] = false;
  } else if (yDistance == 1) {
    current.walls[0] = false;
    next.walls[2] = false;
  }
}

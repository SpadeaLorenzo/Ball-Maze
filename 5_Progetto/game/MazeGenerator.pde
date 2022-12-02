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
    println("X blocco:      " + blockposx + "    ");
    println("Y blocco:      " + blockposy + "    ");

    println("X : " + p.playerX);
    println("Y : " + p.playerY);

    //println(blocks[blockposx][blockposy].toString());

    //collision right
    boolean xright = p.playerX < (blockposx * size)+ size -p.side;
    if (blocks[blockposx][blockposy].walls[1]) {
      if (xright) {
        p.blockR = false;
      } else if (!xright) {
        p.blockR = true;
      }
    }else if(!blocks[blockposx][blockposy].walls[1]){
      p.blockR = false;
    }
    
    
    //collision left
    boolean xleft = p.playerX == (blockposx * size);
    if (blocks[blockposx][blockposy].walls[3]) {
      if (!xleft) {
        p.blockL = false;
      } else if (xleft) {
        p.blockL = true;
      }
    }else if(!blocks[blockposx][blockposy].walls[3]){
      p.blockL = false;
    }
    
    //collision up
    boolean yup = p.playerY == (blockposy * size);
    if (blocks[blockposx][blockposy].walls[0]) {
      if (!yup) {
        p.blockU = false;
      } else if (yup) {
        p.blockU = true;
      }
    }else if(!blocks[blockposx][blockposy].walls[0]){
      p.blockU = false;
    }
    
    //collision up
    boolean ydown = p.playerY < (blockposy * size)+ size -p.side;
    if (blocks[blockposx][blockposy].walls[2]) {
      if (ydown) {
        p.blockD = false;
      } else if (!ydown) {
        p.blockD = true;
      }
    }else if(!blocks[blockposx][blockposy].walls[0]){
      p.blockD = false;
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

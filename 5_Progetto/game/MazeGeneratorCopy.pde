/**
 * Number of colums of the maze.
 */
int cols;

/**
 *Number of rows of the maze.
 */
int rows;

int difficulty = 2;

/**
 * size of the space between the walls of the maze.
 */
int sizeX;
int sizeY;


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
 * Flag to define if the searching algorithm has already passed that spot.
 */
boolean searchNeighborsAdded = false;

Player p;

PGraphics mz;

int gameScreen = 0;

void initiateGame() {
  background(0);
  textAlign(CENTER);
  text("Click to start", displayWidth/2, displayHeight/2);
}
public void mousePressed() {
  // if we are on the initial screen when clicked, start the game
  if (gameScreen==0) {
    startGame();
  }
}

void startGame() {
  gameScreen=1;
}

/**
 * Sets all the variables before the loop starts.
 * Defines the window size.
 */
void setup() {
  fullScreen();

  switch(difficulty) {
  case 0:
    rows = 10;
    cols = 10;
    sizeX = displayWidth/cols;
    sizeY = displayHeight/rows;
    break;
  case 1:
    rows = 15;
    cols = 8;
    sizeX = displayWidth/cols;
    sizeY = displayHeight/rows;
    break;
  case 2:
    rows = 20;
    cols = 20;
    sizeX = displayWidth/cols;
    sizeY = displayHeight/rows;

    break;
  case 3:
    rows = 40;
    cols = 22;
    sizeX = displayWidth/cols;
    sizeY = displayHeight/rows;

    break;
  default:
    rows = 10;
    cols = 10;
    sizeX = displayWidth/cols;
    sizeY = displayHeight/rows;
  }


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
  mz = createGraphics(width, height);
  frameRate(100);
  smooth();
}

public void mazeGenerator() {

  while (!isMazeFinished) { //Maze Generator Here
    fill(193, 50, 193);
    rect(currentMazeBlock.x, currentMazeBlock.y, width, height);
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
  background(92, 92, 92);
  strokeWeight(4);
  stroke(255, 102, 255);
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      blocks[i][j].show();
    }
  }
  mz.endDraw();
}


void draw() {
  if (gameScreen == 0) {
    initiateGame();
  } else if (gameScreen == 1) {
    mazeGenerator();
    p.show();

    if (p.playerX >= 0 && p.playerX <= width   && p.playerY >= 0 && p.playerY <= height   ) {
      //posizione del player nella griglia
      int blockposx = floor(p.playerX/sizeX);
      int blockposy = floor(p.playerY/sizeY);
      //collision right
      boolean xright = p.playerX < (blockposx * sizeX)+ sizeX -p.side -p.speed;
      if (blocks[blockposx][blockposy].walls[1]) {
        if (xright) {
          p.blockR = false;
        } else if (!xright) {
          p.blockR = true;
        }
      } else if (!blocks[blockposx][blockposy].walls[1]) {
        p.blockR = false;
      }
      //collision left
      boolean xleft = p.playerX == (blockposx * sizeX);
      if (blocks[blockposx][blockposy].walls[3]) {
        if (!xleft) {
          p.blockL = false;
        } else if (xleft) {
          p.blockL = true;
        }
      } else if (!blocks[blockposx][blockposy].walls[3]) {
        p.blockL = false;
      }
      //collision up
      boolean yup = p.playerY == (blockposy * sizeY) + p.speed;
    if (blocks[blockposx][blockposy].walls[0]) {
      if (!yup) {
        p.blockU = false;
      } else if (yup) {
        p.blockU = true;
      }
    }else if(!blocks[blockposx][blockposy].walls[0]){
      p.blockU = false;
    }
      //collision down
      boolean ydown = p.playerY < (blockposy * sizeY)+ sizeY -p.side - p.speed;
      if (blocks[blockposx][blockposy].walls[2]) {
        if (ydown) {
          p.blockD = false;
        } else if (!ydown) {
          p.blockD = true;
        }
      } else if (!blocks[blockposx][blockposy].walls[2]) {
        p.blockD = false;
      }
      p.move();
      // riposiziona dentro i bordi
      if (p.playerX > width -p.side) {
        p.playerX = width-p.side;
      }
      if (p.playerY > height -p.side) {
        p.playerY = height-p.side;
      }
      if (p.playerX < 0 ) {
        p.playerX = 0;
      }
      if (p.playerY < 0 ) {
        p.playerY = 0;
      }
    }
  }
  println(p.playerX);
  println("X: " + sizeX);
  println("Y: " + sizeY);
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

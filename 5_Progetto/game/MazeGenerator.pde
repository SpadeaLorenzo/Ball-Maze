/**
 * Number of colums of the maze.
 */
int cols;

/**
 *Number of rows of the maze.
 */
int rows;

/**
 * Sets the difficulty of the maze.
 */
int difficulty;

/**
 * size X of the space between the walls of the maze.
 */
int sizeX;

/**
 * size Y of the space between the walls of the maze.
 */
int sizeY;

/**
 * Array of blocks used in the grid.
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

/**
 * The player.
 */
Player p;

/**
 * Renders the random generated image of the maze.
 */
PGraphics mz;

/**
 * 0 if the menu is loaded , 1 if the game starts.
 */
int gameScreen = 0;

private int rectx, recty;
private boolean rectOver = false;
private int rectSizeX = 200;
private int rectSizeY = 100;
boolean gameCompleted = false;


End end;

/**
 * Loads the menu of the game.
 */
void initiateGame() {
  background(0);
  textAlign(CENTER);
  textSize(35);
  fill(255);
  text("Click right to start , click on Mode to change difficulty", displayWidth/2, displayHeight/2);
  rectx = displayWidth/2 - rectSizeX/2;
  recty = displayHeight/2 + rectSizeY/2;  
  stroke(255);
  if (rectOver) {
    fill(0);
    rect(rectx, recty, rectSizeX, rectSizeY);
  } else if (!rectOver) {
    fill(0);
    rect(rectx, recty, rectSizeX, rectSizeY);
  }
  fill(255);
  text("Mode: " + difficulty, displayWidth/2 - rectSizeX/2 + rectSizeX/2,  displayHeight/2 + rectSizeY/2 + rectSizeY/2);

}
private void update() {
  if (overMode(rectx, recty, rectSizeX, rectSizeY)) {
    rectOver = true;
  } else {
    rectOver = false;
  }
}

private boolean overMode(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width &&
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

public void mouseClicked() {
  if (rectOver && mouseButton == LEFT) {
    if (difficulty == 3) {
      difficulty = 0;
    } else {
      difficulty++;
    }
  }
}

/**
 * Makes the game start.
 */
public void mousePressed() {
  // if we are on the initial screen when clicked, start the game
  if (gameScreen==0 && mouseButton == RIGHT) {
    startGame();
  }
}

/**
 * Sets the game status to "play".
 */
void startGame() {
  gameScreen=1;
}

/**
 * Sets all the variables before the loop starts.
 * Defines the window size.
 */
void setup() {
  fullScreen();
  //Sets the dimension of the image of the maze.
  mz = createGraphics(width, height);
  frameRate(60);
  smooth();
}

private void setDifficulty() {
  //Sets the maze's difficulty.
  switch(difficulty) {
  case 0:
    rows = 5;
    cols = 5;
    sizeX = displayWidth/cols;
    sizeY = displayHeight/rows;
    break;
  case 1:
    rows = 20;
    cols = 20;
    sizeX = displayWidth/cols;
    sizeY = displayHeight/rows;
    break;
  case 2:
    rows = 30;
    cols = 30;
    sizeX = displayWidth/cols;
    sizeY = displayHeight/rows;

    break;
  case 3:
    rows = 40;
    cols = 40;
    sizeX = displayWidth/cols;
    sizeY = displayHeight/rows;

    break;
  default:
    rows = 10;
    cols = 10;
    sizeX = displayWidth/cols;
    sizeY = displayHeight/rows;
  }
}

private void setupPlayer() {

  //Istantiate the player.
  p = new Player(20);
}

private void setupEnd() {
  //Creates the end point.
  int endx = (int) random(cols);
  int endy = (int) random(rows);
  end = new End(endx * sizeX, endy * sizeY);
}


private void setupBlocks() {
  //creates the block grid.
  blocks = new Block[rows][cols];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      blocks[i][j] = new Block(i, j);
    }
  }

  //Adds neighbours for each block in the maze.
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      blocks[i][j].addNeighbors();
    }
  }

  //Returns the position to the top left corner.
  currentMazeBlock = blocks[0][0];
  //The top left corner block is set to "visited".
  currentMazeBlock.visitedByMaze = true;
}

/**
 * Generates a random maze.
 */
public void mazeGenerator() {

  while (!isMazeFinished) {
    //Randomly creates the structure of the maze removing walls.
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
}

public void drawMaze() {

  //Begins the creation of the maze image.
  mz.beginDraw();
  background(92, 92, 92);
  strokeWeight(4);
  stroke(255, 102, 255);
  //Shows all blocks.
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      blocks[i][j].show();
    }
  }
  mz.endDraw();
}

/**
 * Loop where all the graphic contents are displayed.
 */
void draw() {

  //menu
  if (gameScreen == 0) {
    initiateGame();
    update();
    setDifficulty();
    setupBlocks();
    setupEnd();
    setupPlayer();
    isMazeFinished = false;
    mazeGenerator();

    // game
  } else if (gameScreen == 1) {
    drawMaze();
    end.show();
    p.show();

    if (p.playerX >= 0 && p.playerX <= width   && p.playerY >= 0 && p.playerY <= height   ) {
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
      boolean yup = p.playerY < (blockposy * sizeY) + p.speed;
      if (blocks[blockposx][blockposy].walls[0]) {
        if (!yup) {
          p.blockU = false;
        } else if (yup) {
          p.blockU = true;
        }
      } else if (!blocks[blockposx][blockposy].walls[0]) {
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

      //Resets the player inside the grid
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
    if ((p.playerX >= end.blockx && p.playerX <= end.blockx+ end.size)&& (p.playerY >= end.blocky && p.playerY <= end.blocky + end.size)) {
      gameScreen = 0;
      gameCompleted = true;
      redraw();
    }
  }

  // debug
  println(p.playerX);
  println("X: " + sizeX);
  println("Y: " + sizeY);
}


/**
 * Removes the Walls of the blocks to generate the maze structure.
 * @param current the current block under check.
 * @param next the next block to inspect.
 */
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

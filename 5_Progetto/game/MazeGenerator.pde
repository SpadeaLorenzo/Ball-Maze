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

/**
 * List of possible blocks to visit in the solving of the maze.
 */
ArrayList<Block> openSet = new ArrayList<Block>();

/**
 * Flag to set true when the path to the goal is found.
 */
boolean pathFound = false;







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

/**
 *
 */
private int rectx, recty;

/**
 *
 */
private boolean rectOver = false;

/**
 *
 */
private int rectSizeX = 200;

/**
 *
 */
private int rectSizeY = 100;

/**
 *
 */
boolean gameCompleted = false;


/**
 * End point of the Maze.
 */
End end;

/**
 * Prfect score of the maze.
 */
int score = 0;

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
  text("Mode: " + difficulty, displayWidth/2 - rectSizeX/2 + rectSizeX/2, displayHeight/2 + rectSizeY/2 + rectSizeY/2 + 10);
  text("Copyrights", 100, 100);
  String[] lines = loadStrings("ranking.txt");
  text(lines[0], 120, 150 +  30);
}

void finalizeGame() {
  background(0);
  textAlign(CENTER);
  textSize(35);
  fill(255);
  text("press space to return to main menu", displayWidth/2, displayHeight/2);
  if (keyPressed == true) {
    if (key == ' ') {
      gameCompleted = true;
      gameScreen = 0;
    }
  }
}


/**
 * Update the position of the mouse.
 */
private void update() {
  if (overMode(rectx, recty, rectSizeX, rectSizeY)) {
    rectOver = true;
  } else {
    rectOver = false;
  }
}

/**
 *
 */
private boolean overMode(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width &&
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

/**
 *
 */
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



private void getSteps() {
  startSearchBlock = blocks[0][0];
  finishSearchBlock =  new Block(end.col, end.row);
  if (!searchNeighborsAdded) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        blocks[i][j].addMazeNeighbors();
      }
    }
    searchNeighborsAdded = true;
    startSearchBlock.g = 0;
    startSearchBlock.f = heuristic(startSearchBlock, finishSearchBlock);
    openSet.add(startSearchBlock);
  }
  if (openSet.size() > 0) {
    currentSearchBlock = lowestFinOpenSet();

    if (currentSearchBlock.thisRow == finishSearchBlock.thisRow && currentSearchBlock.thisCol == finishSearchBlock.thisCol  ) {
      pathFound = true;
      reconstructActualPath();
      score = actualPath.size();
      noLoop();
    }
    if (!pathFound) {
      openSet.remove(currentSearchBlock);
      for (Block ngbr : currentSearchBlock.mazeNeighbors) {
        float tent_gScore = currentSearchBlock.g + 1;
        if (tent_gScore < ngbr.g) {
          ngbr.prev = currentSearchBlock;
          ngbr.g = tent_gScore;
          ngbr.f = ngbr.g + heuristic(ngbr, finishSearchBlock);
          if (!openSet.contains(ngbr)) {
            openSet.add(ngbr);
          }
        }
      }
    }
  } else if (pathFound) {
    noLoop();
  }
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
  p = new Player();
}

private void setupEnd() {
  //Creates the end point.
  int endx = (int) random(cols);
  int endy = (int) random(rows);
  end = new End(endx * sizeX, endy * sizeY, endy, endx);
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
  startSearchBlock = blocks[0][0];
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
  } else if (gameScreen == 2) {
    finalizeGame();
  } else if (gameScreen == 1) {
    drawMaze();
    end.show();
    if (!pathFound) {
      getSteps();
    }

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
      boolean xleft = p.playerX <= (blockposx * sizeX) + p.speed;
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
      gameScreen = 2;

      finalizeGame();
      redraw();
    }
  }
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

ArrayList reconstructActualPath() {
  Block current = currentSearchBlock;
  actualPath.add(current);
  while (current != startSearchBlock) {
    actualPath.add(current);
    current = current.prev;
  }
  return actualPath;
}

ArrayList reconstructSearchPath() {
  if (isMazeFinished) {
    Block current = currentSearchBlock;
    searchedPath.add(current);
    while (current != startSearchBlock) {
      searchedPath.add(current);
      current = current.prev;
    }
  }
  return searchedPath;
}

float heuristic(Block from, Block to) {
  float distance = 0.0;
  distance = dist(from.thisRow, from.thisCol, to.thisRow, to.thisCol);
  return distance;
}

Block lowestFinOpenSet() {
  Block lowestFScore = openSet.get(0);
  for (Block block : openSet) {
    if (block.f < lowestFScore.f) {
      lowestFScore = block;
    }
  }
  return lowestFScore;
}

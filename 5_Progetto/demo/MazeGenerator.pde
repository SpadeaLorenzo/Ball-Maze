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
int size =  40;

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

/**
 * List of possible blocks to visit in the solving of the maze.
 */
ArrayList<Block> openSet = new ArrayList<Block>();

/**
 * Flag to set true when the path to the goal is found.
 */
boolean pathFound = false;


/**
 * Sets all the variables before the loop starts.
 * Defines the window size.S
 */
void setup() {
  size(600, 600);
  rows = floor(height / size);
  cols = floor(width / size);
  blocks = new Block[rows][cols];

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

  startSearchBlock = blocks[0][0];
  finishSearchBlock = blocks[parseInt(random(0, rows - 1))][cols - 1];

  frameRate(30);
  smooth();
}


void draw() {

  if (!isMazeFinished) { //Maze Generator Here
    background(0, 255, 255);
    //background(0);
    strokeWeight(4);
    stroke(255, 255, 0);
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        blocks[i][j].show();
      }
    }

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
  } else {
    startSearchBlock.makeRect(255, 0, 0);
    finishSearchBlock.makeRect(255, 0, 0);
    //A* Search Algorithm Here
    if (!searchNeighborsAdded) { //Add neighbors only once
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          blocks[i][j].addMazeNeighbors();
        }
      }
      searchNeighborsAdded = true;
      frameRate(15);
      //Any inital setup before starting search algorithm.
      startSearchBlock.g = 0;
      startSearchBlock.f = heuristic(startSearchBlock, finishSearchBlock);
      openSet.add(startSearchBlock);
    }
    if (openSet.size() > 0) { //runs until reaches a decision
      currentSearchBlock = lowestFinOpenSet();
      //currentSearchBlock.makeRect(255, 255, 255);
      if (currentSearchBlock == finishSearchBlock) {
        pathFound = true;
        reconstructActualPath();
        for (int i = 0; i < actualPath.size() - 1; i++) {
          actualPath.get(i).makeLine(actualPath.get(i + 1), 255, 0, 0);
        }
        startSearchBlock.makeRect(0, 255, 0);
        finishSearchBlock.makeRect(0, 255, 0);
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
        reconstructSearchPath();
        for (Block block : searchedPath) {
          block.makeRect(255, 255, 0);
        }
        startSearchBlock.makeRect(0, 255, 0);
        finishSearchBlock.makeRect(0, 255, 0);
      }
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          blocks[i][j].show();
        }
      }
    } else if (pathFound) {
      noLoop();
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


ArrayList reconstructSearchPath() {
  Block current = currentSearchBlock;
  searchedPath.add(current);
  while (current != startSearchBlock) {
    searchedPath.add(current);
    current = current.prev;
  }
  return searchedPath;
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

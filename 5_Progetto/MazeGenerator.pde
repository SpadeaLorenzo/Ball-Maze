int columns;
int rows;
int size = 50;
Block[][] blocks;
Block currentBlock;
ArrayList<Block> stack = new ArrayList<Block>();
boolean isFinished = false;



void setup() {
  size(500, 500);
  rows = height / size;
  columns = width / size;
  blocks = new Block[rows][columns];

  for (int i = 0; i < rows; i++ ) {
    for (int j = 0; j < columns; j++) {
      blocks[i][j] = new Block(i, j);
    }
  }
  //ciclo obbligatorio perché i prossimi blocchi non sono ancora conosciuti.
  for (int i = 0; i < rows; i++ ) {
    for (int j = 0; j < columns; j++) {
      blocks[i][j].addNeighbours();
    }
  }
  currentBlock = blocks[0][0];
  currentBlock.visited = true;

  frameRate(30);
}

void draw() {

  if (!isFinished) {
    background(233, 64, 64);
    strokeWeight(2);

    for (int i = 0; i < rows; i++ ) {
      for (int j = 0; j < columns; j++) {
        blocks[i][j].show();
      }
    }
    fill(193, 50, 193);
    rect(currentBlock.x, currentBlock.y, size, size);
  }

  if (currentBlock.hasUnvisitedNeighbours()) {
    Block next = currentBlock.pickRandomNeighbour();
    stack.add(currentBlock);
    removeWalls(currentBlock, next);
    currentBlock = next;
  } else if (stack.size() > 0) {
    Block next = stack.get(stack.size() -1);
    stack.remove(next);
    currentBlock = next;
  } else if (isFinished) {
    keyPressed();
  } else {
    print("Maze done");
    isFinished = true;
    for (int i = 0; i < rows; i++ ) {
      for (int j = 0; j < columns; j++) {
        blocks[i][j].show();
      }
    }
    fill(193, 50, 193);
    rect(currentBlock.x, currentBlock.y, size, size);
  }
}


void keyPressed() {
  currentBlock = blocks[0][0];
  if (keyCode == DOWN) {
    fill(193, 50, 193);
    rect(currentBlock.x, currentBlock.y, size, size);

    currentBlock.y += size;
  } else if (keyCode == LEFT) {
    print("sinistra");

    currentBlock.x -= size;
  }
}


void removeWalls(Block current, Block next) {
  int distanceX = current.thisRow - next.thisRow;
  int distanceY = current.thisColum -next.thisColum;
  if (distanceX == -1) {
    current.walls[1] = false;
    next.walls[3] = false;
  } else if (distanceX == 1) {
    current.walls[3] = false;
    next.walls[1] = false;
  }
  if (distanceY == -1) {
    current.walls[2] = false;
    next.walls[0] = false;
  } else if (distanceY == 1) {
    current.walls[0] = false;
    next.walls[2] = false;
  }
}

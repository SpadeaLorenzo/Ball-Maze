class Player {
  int playerY;
  int playerX;
  int side = 20;
  int speed = 5;
  boolean blockL = false;
  boolean blockR = false;
  boolean blockU = false;
  boolean blockD = false;

  public Player() {
    this.playerX = 0;
    this.playerY = 0;
  }
  public void show() {
    fill(255, 100, 100);
    rect(playerX, playerY, side, side);
  }

  public void move() {
    moveRight();
    moveLeft();
    moveUp();
    moveDown();
  }
  public void moveRight() {
    if (keyPressed == true) {
      if (keyCode == RIGHT ) {
        if (!(blockR)) {
          p.playerX += speed;
        }
      }
    }
  }

  public void moveLeft() {
    if (keyPressed == true) {
      if (keyCode == LEFT) {
        if (!blockL) {
          p.playerX -= speed;
        }
      }
    }
  }

  public void moveUp() {
    if (keyPressed == true) {
      if (keyCode == UP) {
        if (!blockU) {
          p.playerY -= speed;
        }
      }
    }
  }

  public void moveDown() {
    if (keyPressed == true) {
      if (keyCode == DOWN ) {
        if (!blockD) {
          p.playerY += speed;
        }
      }
    }
  }
}

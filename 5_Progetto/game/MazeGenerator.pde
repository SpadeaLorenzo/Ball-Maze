class Player {
  int playerY;
  int playerX;
  int side = 20;
  int speed = 1;
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
  
  public void move(){
    moveRight();
    moveLeft();
    moveUp();
    moveDown();
  }
  public void moveRight() {
    if (keyPressed == true) {
      if (keyCode == RIGHT && !blockR) {
        p.playerX += speed;
      }
    }
  }

  public void moveLeft() {
    if (keyPressed == true) {
      if (keyCode == LEFT && !blockL) {
        p.playerX -= speed;
      }
    }
  }

  public void moveUp() {
    if (keyPressed == true) {
      if (keyCode == UP  && !blockU) {
        p.playerY -= speed;
      }
    }
  }

  public void moveDown() {
    if (keyPressed == true) {
      if (keyCode == DOWN  && !blockD) {
        p.playerY += speed;
      }
    }
  }
}
class Player {
  int playerY;
  int playerX;
  int side = 20;
  int speed = 5;
   boolean allowL = true;
   boolean allowR = true;
   boolean allowU = true;
   boolean allowD = true;

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
      if (keyCode == RIGHT && allowR) {
        p.playerX += speed;
      }
    }
  }

  public void moveLeft() {
    if (keyPressed == true) {
      if (keyCode == LEFT && allowL) {
        p.playerX -= speed;
      }
    }
  }

  public void moveUp() {
    if (keyPressed == true) {
      if (keyCode == UP  && allowU && allowU) {
        p.playerY -= speed;
      }
    }
  }

  public void moveDown() {
    if (keyPressed == true) {
      if (keyCode == DOWN  && allowD) {
        p.playerY += speed;
      }
    }
  }
}

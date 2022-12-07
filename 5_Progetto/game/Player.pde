class Player {
  /**
   * Y position of the player in the grid.
   */
  int playerY;

  /**
   * X position of the player in the grid.
   */
  int playerX;

  /**
   * Side dimension of the player.
   */
  int side = 20;

  /**
   * Movement speed of the player.
   */
  int speed = 5;

  /**
   * Allows left movements.
   */
  boolean blockL = false;

  /**
   * Allows right movements.
   */
  boolean blockR = false;

  /**
   * Allows up movements.
   */
  boolean blockU = false;

  /**
   * Allows down movements.
   */
  boolean blockD = false;


  /**
   * Istantiate a player in the top left corner of the grid.
   */
  public Player() {
    this.playerX = 0;
    this.playerY = 0;
  }

  /**
   * Shows the player in the grid.
   */
  public void show() {
    fill(255, 100, 100);
    rect(playerX, playerY, side, side);
  }

  /**
   * Calls all methods to move the player.
   */
  public void move() {
    moveRight();
    moveLeft();
    moveUp();
    moveDown();
  }

  /**
   * Moves the player to the right.
   */
  public void moveRight() {
    if (keyPressed == true) {
      if (keyCode == RIGHT ) {
        if (!(blockR)) {
          p.playerX += speed;
        }
      }
    }
  }

  /**
   *Moves the player to the left.
   */
  public void moveLeft() {
    if (keyPressed == true) {
      if (keyCode == LEFT) {
        if (!blockL) {
          p.playerX -= speed;
        }
      }
    }
  }

  /**
   * Moves the player up.
   */
  public void moveUp() {
    if (keyPressed == true) {
      if (keyCode == UP) {
        if (!blockU) {
          p.playerY -= speed;
        }
      }
    }
  }

  /**
   * Moves the player down.
   */
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
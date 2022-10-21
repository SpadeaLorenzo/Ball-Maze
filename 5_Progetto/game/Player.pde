class Player {
  float playerY;
  float playerX;
  int rad = 15;

  public Player() {
    this.playerX = rad;
    this.playerY = rad;
  }
  public void show() {
    fill(255, 100, 100);
    ellipse(playerX, playerY, 2*rad, 2*rad);
  }

  /**
   * Changes the coordinate of the player inside the window screen.
   */
  public void move() {
    if (keyPressed == true) {
      if      (keyCode == UP    && p.playerY- p.rad >= 0     ) p.playerY -= 5;
      else if (keyCode == DOWN  && p.playerY+p.rad <= height)  p.playerY +=5;
      else if (keyCode == LEFT  && p.playerX-p.rad >= 0     )  p.playerX -=5;
      else if (keyCode == RIGHT && p.playerX+p.rad <= width )  p.playerX +=5;
    }
  }
}

void checkCollision(){
  
}

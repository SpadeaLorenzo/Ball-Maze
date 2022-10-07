class Block {

  int x;
  int y;
  int thisRow; 
  int thisColum;
  boolean visited = false;
  boolean walls[] = {true, true, true, true};
  ArrayList<Block> neighbours = new ArrayList<Block>();  


  Block (int r , int c){
      x = r * size;
      y = c * size;
      thisRow = r;
      thisColum = c;
  }
  
  void show(){
    if(walls[0]){
      line(x , y , x + size , y);
    }

    if(walls[1]){
      line(x + size , y , x + size , y + size);
    }

    if(walls[2]){
      line(x + size,  y + size , x  , y + size);
    }

    if(walls[3]){
      line(x , y + size , x  , y);
    }

    if(visited){
      noStroke();
      fill(255,255,255);
      rect(x,y,size,size);
      stroke(0);
    }
  }

  void addNeighbours(){
    
    if(thisRow > 0){
      neighbours.add(blocks[thisRow - 1][thisColum]);
    }

    if(thisColum < columns -1){
      neighbours.add(blocks[thisRow][thisColum + 1]);
    }

    if(thisRow < rows - 1){
      neighbours.add(blocks[thisRow + 1][thisColum]);
    }

    if(thisColum > 0){
      neighbours.add(blocks[thisRow][thisColum -1]);
    }
  }

  boolean hasUnvisitedNeighbours(){
    for(Block neighbour : neighbours){
      if(!neighbour.visited){
        return true;
      }
    }
    return false;
  }

  Block pickRandomNeighbour(){
    Block ngbr = neighbours.get(floor(random(0 , neighbours.size())));   
    while (ngbr.visited) {
      neighbours.remove(ngbr);
      ngbr = neighbours.get(floor(random(0 , neighbours.size())));    
    }
    ngbr.visited = true;
    neighbours.remove(ngbr);
    return ngbr;
  }
}

public class End{
   int blockx;
   int blocky;
   int row;
   int col;
   int size = 25;
   
   public End(int x, int y , int col , int row){
     this.blockx = x;
     this.blocky = y; 
     this.row = row;
     this.col = col;
   }
   
   public void show() {
    fill(124,252,0);
    rect(blockx, blocky, size ,size);
  }
}

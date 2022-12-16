public class End{
   int blockx;
   int blocky;
   int size = 25;
   
   public End(int x, int y){
     this.blockx = x;
     this.blocky = y;  
   }
   
   public void show() {
    fill(124,252,0);
    rect(blockx, blocky, size ,size);
  }
}
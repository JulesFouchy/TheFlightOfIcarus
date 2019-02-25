class AirBubble{
  PVector pos ;
  color colour = #95F0FF ;
  float r = random(10,15) ;
  float vertSpeed = random(1,1.5) ;
  float noiseSeed = random(1000) ;
  
  AirBubble( float x , float y ){
    pos = new PVector( x , y ) ;
  }
  
  void show(){
    noStroke() ;
    fill( colour , 150 ) ;
    ellipse( pos.x , pos .y , 2*r , 2*r ) ;
  }
  
  void move(){
    pos.y -= vertSpeed ;
    pos.x += 1*noise(frameCount*0.01+noiseSeed)-0.5 ;
  }
  
  void update(){
    move() ;
    show() ;
  }
}

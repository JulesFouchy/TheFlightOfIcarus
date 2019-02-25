class ScumParticle{
  float x , y ;
  float yShift = 0 ;
  float yVar = 0.01 ;
  float r ;
  color colour ;
  float alpha = 110 ;
  
  ScumParticle( float x_ , float y_ , float r_ , color colour_ ){
    x = x_ ;
    y = y_ ;
    r = r_ ;
    colour = colour_ ;
  }
  
  void move(){
    x += random(-1,1) ;
    yShift += random(-0.1,0.1) ;
  }
  
  void show(){
    noStroke() ;
    fill(colour,alpha) ;
    ellipse( x , y*(1+yVar*sin(yShift)) , 2*r , 2*r ) ;
  }
}

class Scum{
  int nbParticles = 1000 ;
  ScumParticle particles[] ;
  
  Scum( float y ){
    particles = new ScumParticle[nbParticles] ;
    for( int k = 0 ; k < nbParticles ; ++k ){
      particles[k] = new ScumParticle( random(width) , y , random(2,5) , lerpColor(#7FEAF7,#6AD5F5,random(1)) ) ;
    }
  }
  
  void update(){
    for( int k = 0 ; k < nbParticles ; ++k ){
      particles[k].show() ;
      particles[k].move() ;
    }
  }
}

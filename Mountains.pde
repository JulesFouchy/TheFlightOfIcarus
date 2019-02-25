float f( float x ){
  return 2*abs(x/width*height) ;
}

void mountain( PGraphics pg , float xMin , float xMax , float y0 , float mountainHeight , float halfHeightVar){
  float dx = 1 ;
  float scaleToPerlinSpace = 0.01 ;
  float probaPicUp = 0.1 ;
  float probaPicDown = 0.06 ;
  
  float xMid = (xMin+xMax)/2 ;
  float xLength = xMax-xMin ;
  
  int sgn = 1 ;
  float b = 0 ;
  
  PShape s = createShape() ;
  s.beginShape() ;
  s.fill(lerpColor(#A54812,#7E2806,random(1))) ;
  s.stroke(#58270B) ;
  //s.noStroke() ;
  s.strokeWeight(0.5) ;
  //s.vertex( -xLength/2 , 0 ) ;
  float x = -xLength/2 ;
  float y = -1 ;
  
  while( y < 0 || x < 0 ){
    float x_ = x * scaleToPerlinSpace ;
    float yVar = sgn*map(noise( x_ ),0,1,-halfHeightVar,halfHeightVar) + b ;
    y = -(yVar + mountainHeight-abs(x)*mountainHeight/xLength*2) ;
    if( y < 0 ){
      s.vertex( x , y ) ;
    }
    
    if( random(1) < ( sgn==-1 ? probaPicUp : probaPicDown ) ){
      //println( "change at " , x ) ;
      b = 2* sgn*map(noise( x_ ),0,1,-halfHeightVar,halfHeightVar) + b ;
      sgn *= -1 ;
    }
    
    x+=dx ;
  }
  //s.vertex( xLength/2 , 0 ) ;
  s.endShape() ;
  pg.shape( s , xMid , y0 ) ;
  //s.scale( 0.5,0.5) ;
  //shape( s , xMid , height ) ;
}

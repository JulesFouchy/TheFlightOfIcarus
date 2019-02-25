PShape bentTrg( float length , float xTip , float yTip , float maxAngle ){
  PShape s = createShape() ;
  s.beginShape() ;
  float maxR = sqrt( sq(xTip+length/2) + sq(yTip) ) ;
  float minAngle = atan2( yTip , xTip+length/2 ) +PI ;
  for( float t = 0 ; t <= 1 ; t += 0.005 ){
    float agl = map( t , 0 , 1 , minAngle , maxAngle ) ;
    float r = map( t , 0 , 1 , maxR , 0 ) ;
    s.vertex( xTip + r*cos(agl) , yTip + r*sin(agl) ) ;
  }
  maxR = sqrt( sq(xTip-length/2) + sq(yTip) ) ;
  minAngle = atan2( yTip , xTip-length/2 ) +PI ;
  for( float t = 1 ; t >= 0 ; t -= 0.005 ){
    float agl = map( t , 0 , 1 , minAngle , maxAngle )  ;
    float r = map( t , 0 , 1 , maxR , 0 ) ;
    s.vertex( (xTip + r*cos(agl)) , yTip + r*sin(agl) ) ;
  }
  s.endShape() ;
  return s ;
}

PShape waveCrest( float length , float xTip , float yTip ){
  float maxAngle = 0.75*TAU ;
  PShape wave = createShape(GROUP) ;
  //Shape
  PShape s = bentTrg( length , xTip , yTip , maxAngle ) ;
  s.setFill( #1C35AD ) ;
  s.setStroke(false) ;
  wave.addChild(s) ;
  //Lines
  for( int k = 0 ; k < 4 ; ++ k ){
    float x = length/2 *(1-exp(-k*0.6)) ;
    float t0 = 0;//random(0.05,0.1) ;
    float t1 = 1;//random(0.9,0.95) ;
    PShape line = createShape() ;
    line.beginShape() ;
    line.stroke( lerpColor(#7FEAF7,#6AD5F5,random(1)) ) ;
    line.noFill() ;
    float maxR = sqrt( sq(xTip-x) + sq(yTip) ) ;
    float minAngle = atan2( yTip , xTip-x ) +PI ;
    for( float t = t0 ; t <= t1 ; t += 0.005 ){
      float agl = map( t , 0 , 1 , minAngle , maxAngle )  ;
      float r = map( t , 0 , 1 , maxR , 0 ) ;
      line.vertex( (xTip + r*cos(agl)) , yTip + r*sin(agl) ) ;
    }
    line.endShape() ;
    wave.addChild( line ) ;
  }
  return wave ;
}

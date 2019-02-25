PShape feather( float length , color colour ){
  float accrocheLength = 0.15*length ;
  float maxHalfWeight = 0.13*length ;
  float midLineRatio = 0.7 ;
  int nbV = 6 ;
  float Vlength = 0.08*length ;
  float Vangle = TAU*0.07 ;
  
  PShape s = createShape( GROUP ) ;
  //Accroche
  float x = accrocheLength ;
  PShape accroche = createShape() ;
  accroche.beginShape() ;
  accroche.stroke(colour) ;
  accroche.vertex( 0 , 0 ) ;
  accroche.vertex( x , 0 ) ;
  accroche.endShape() ;
  s.addChild( accroche ) ;
  //Plume
  PShape plume = createShape() ;
  plume.beginShape() ;
  plume.noStroke() ;
  plume.fill( colour ) ;
  plume.curveVertex( x,0 ) ;
  plume.curveVertex( x,0 ) ;
  plume.curveVertex( x+length/2,maxHalfWeight ) ;
  plume.curveVertex( x+length,0 ) ;
  plume.curveVertex( x+length,0 ) ;
  plume.endShape() ;
  plume.beginShape() ;
  plume.curveVertex( x,0 ) ;
  plume.curveVertex( x,0 ) ;
  plume.curveVertex( x+length/2,-maxHalfWeight ) ;
  plume.curveVertex( x+length,0 ) ;
  plume.curveVertex( x+length,0 ) ;
  plume.endShape() ;
  s.addChild( plume ) ;
  //Middle line
  PShape middleLine = createShape() ;
  middleLine.beginShape() ;
  middleLine.stroke(0) ;
  middleLine.strokeWeight(0.5) ;
  middleLine.vertex( x + (1-midLineRatio)/2*length  , 0 ) ;
  middleLine.vertex( x +(1+midLineRatio)/2*length , 0 ) ;
  middleLine.endShape() ;
  //Vs
  x = x + (1-midLineRatio)/2*length ;
  float dx = (midLineRatio*length)/(nbV+1) ;
  for( int k = 0 ; k < nbV ; ++k ){
    x += dx ;
    middleLine.beginShape() ;
    middleLine.stroke(0) ;
    middleLine.vertex( x , 0 ) ;
    middleLine.vertex( x+Vlength*cos(Vangle) , 0+Vlength*sin(Vangle) ) ;
    middleLine.endShape() ;
    middleLine.beginShape() ;
    middleLine.vertex( x , 0 ) ;
    middleLine.vertex( x+Vlength*cos(Vangle) , 0-Vlength*sin(Vangle) ) ;
    middleLine.endShape() ;
  }
  s.addChild( middleLine ) ;
  
  return s ;
}

PShape wing( float r , color colour ){
  PShape s = createShape(GROUP) ;
  for( float t = -PI*0.7 -PI/2 ; t <= 0 -PI/2 ; t+=0.025*TAU ){
    t += random(-0.05,0.05) ;
    PShape feather = feather( 100 , colour ) ;
    feather.rotate( TAU/4) ;
    feather.translate( r*cos(t) +r/2*cos(2*t-TAU/4) , r*sin(t) +r/2*sin(2*t-TAU/4) -r/2 ) ;
    s.addChild( feather ) ;
  }
  return s ;
}

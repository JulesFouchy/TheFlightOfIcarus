class SharkBodySection{
  PVector hd ;
  PVector tl ;
  float agl ;
  float length ;
  float weight ;
  
  SharkBodySection( float x , float y , float len , float weight ){
    hd = new PVector(x,y) ;
    length = len ;
    this.weight = weight ;
    tl = new PVector(x-len,y) ;
  }
  
  void moveTo( float x , float y ){
    hd.set(x,y) ;
    agl = atan2( y-tl.y , x-tl.x ) ;
    tl.set( x - cos(agl)*length , y -length*sin(agl) ) ;
  }
  
  void show(color colour ){
    noStroke() ;
    fill( colour ) ;
    pushMatrix() ;
    scale(-1,1) ;
    translate(-width,0) ;
    translate( (hd.x+tl.x)/2 , (hd.y+tl.y)/2 ) ;
    rotate(agl) ;
    rectMode( CENTER ) ;
    rect( 0 , 0 , PVector.sub(tl,hd).mag() , weight ) ;
    popMatrix() ;
  }
}

PShape tooth( float length , float heigh ){
  PShape s = createShape() ;
  s.setStroke(false) ;
  s.setFill(color(255)) ;
  s.beginShape() ;
  s.vertex( -length/2 , 0 ) ;
  s.vertex( length/2 , 0 ) ;
  s.vertex( 0 , heigh ) ;
  s.endShape() ;
  return s ;
}

float sharkBonusWeight( float x , float lambda , float mu , float alpha ){
  return lambda*x*exp(-mu*pow(x,alpha)) ;
}

class Shark{
  color skinColour = #A0A0A0 ;
  int nbSections = 10 ;
  float bodyLength = width * 0.17 ;
  float bodyPow = 0.85 ;
  SharkBodySection[] sections ;
  PShape head ;
  float headRadius ;
  float eyeRatio = 0.25 ;
  PShape tail ;
  float tailLength = 75 ;
  float tailWeight0 ;
  float tailWeight1 = 100 ;
  PShape mouth ;
  float mouthStartAngle = -0.05*TAU ;
  float mouthEndAngle = mouthStartAngle + 0.2*TAU ;
  float mouthMinRadius ;
  float mouthLength  ;
  //Fin
  PShape fin ;
  float finLength ;
  float finXtip ;
  float finYtip ;
  float finMaxAngle ;
  //Trajectory
  float coefDom , xMeet , yMeet ;
  int t0 ;
  float x0 ;
  float tMeeting ;
  float xSpeed ;
  
  Shark( float x , float y , int t0 , float x0 , float y0 , float v0x , float v0y){
    //Body
    sections = new SharkBodySection[nbSections] ;
    float sectionLength = bodyLength/(nbSections-1) ;
    float derivativeAt0 = 0.8 ;
    float pow = 1.5;
    float maxWeightPos = bodyLength *0.35 ;
    float mu = 1/(pow*pow(maxWeightPos,pow)) ;
    for( int k = 0 ; k < nbSections ; ++k ){
      float weight = 60+ sharkBonusWeight(k*sectionLength,derivativeAt0,mu,pow) ;//80*t*exp(-pow(t,bodyPow)) ;//map( k , 0 , nbSections-1 , 80 , 50 ) ;
      sections[k] = new SharkBodySection( x , y , sectionLength , weight ) ;
      x -= sectionLength ;
    }
    //Fin
    finLength = 75 ;
    finXtip = 30 ;
    finYtip = 60 ;
    finMaxAngle = 0.5*TAU ;
    fin = bentTrg( finLength , finXtip , finYtip , finMaxAngle ) ;
    fin.setStroke(false) ;
    fin.setFill(skinColour) ;
    //Tail
    float tailWeight0 = sections[nbSections-1].weight ;
    tail = createShape() ;
    tail.setStroke(false) ;
    tail.setFill( skinColour ) ;
    tail.beginShape() ;
    tail.vertex( 0 , -tailWeight0/2 ) ;
    tail.vertex( -tailLength , -tailWeight1/2 ) ;
    tail.vertex( -tailLength*0.7 , 0 ) ;
    tail.vertex( -tailLength , tailWeight1/2 ) ;
    tail.vertex( 0 , tailWeight0/2 ) ;
    tail.endShape() ;
    //Head
    headRadius = sections[0].weight/2 ;
    head = createShape(GROUP) ;
      //head shape
    PShape headShape = createShape(ARC, 0 , 0 , 2*headRadius , 2*headRadius,-TAU/4,TAU/4 ) ;
    headShape.setStroke(false) ;
    headShape.setFill( skinColour ) ;
    head.addChild( headShape ) ;
      //Eye
    PShape eye = createShape(ELLIPSE, headRadius/2 , -headRadius/2 , eyeRatio*headRadius , eyeRatio*headRadius ) ;
    eye.setStroke(false) ;
    eye.setFill(color(255,255,255)) ;
    head.addChild( eye ) ;
      //Pupille
    PShape pupille = createShape(ELLIPSE, headRadius/2 , -headRadius/2 , 0.3*eyeRatio*headRadius , 0.3*eyeRatio*headRadius ) ;
    pupille.setStroke(false) ;
    pupille.setFill(color(0,0,0)) ;
    head.addChild( pupille ) ;
      //Mouth
    mouthMinRadius = 0.1*headRadius ;
    mouthLength = headRadius - mouthMinRadius ;
    mouth = createShape(GROUP) ;
    PShape mouthBack = createShape(ARC,mouthMinRadius*cos((mouthStartAngle+mouthEndAngle)/2),mouthMinRadius*sin((mouthStartAngle+mouthEndAngle)/2),2*headRadius,2*headRadius,mouthStartAngle,mouthEndAngle) ;
    mouthBack.setStroke(false) ;
    mouthBack.setFill(color(0)) ;
    //mouthBack.beginShape() ;
    //mouthBack.vertex( headRadius*cos(mouthEndAngle) , headRadius*sin(mouthEndAngle) ) ;
    //mouthBack.quadraticVertex( 0 , 0.25*headRadius, mouthMinRadius*cos((mouthStartAngle+mouthEndAngle)/2) , mouthMinRadius*cos((mouthStartAngle+mouthEndAngle)/2) ) ;
    //mouthBack.quadraticVertex( 0 , 0, headRadius*cos(mouthStartAngle) , headRadius*sin(mouthStartAngle) ) ;
    //mouthBack.endShape() ;
    mouth.addChild(mouthBack) ;
        //Teeth
    int nbTeeth = 4 ;
    float toothLength = mouthLength/nbTeeth ;
    for( int k = 0 ; k < nbTeeth ; ++k ){
      PShape tooth = tooth( toothLength , 1.618*toothLength ) ;
      float agl = mouthStartAngle ;
      float r = headRadius-toothLength*k ;
      tooth.rotate( agl ) ;
      tooth.translate( r*cos(agl) , r*sin(agl)) ;
      mouth.addChild( tooth ) ;
    }
    for( int k = nbTeeth-1 ; k >= 0 ; --k ){
      PShape tooth = tooth( toothLength , -1.618*toothLength ) ;
      float agl = mouthEndAngle ;
      float r = headRadius-toothLength*(k+0.5) ;
      tooth.rotate( agl ) ;
      tooth.translate( r*cos(agl) , r*sin(agl)) ;
      mouth.addChild( tooth ) ;
    }
    head.addChild(mouth) ;
    //Trajectory
    coefDom = 0.003 ;
    xSpeed = -40 ;
    yMeet = ySea - 150 ;
    xMeet = calculateXmeeting( yMeet , x0 , v0x , v0y ) ;
    this.t0 = t0 ;
    this.x0 = x0 ;
    tMeeting = calculateTmeeting( v0x , xMeet , x0 ) ;
  }
  
  void moveTo( float x , float y ){
    for( int k = 0 ; k < nbSections ; ++k ){
      sections[k].moveTo( x , y ) ;
      x = sections[k].tl.x ;
      y = sections[k].tl.y ;
    }
  }
  
  void show(){
    pushMatrix() ;
    scale(1,-1) ;
    translate(0,-height) ;
    //Body
    beginShape() ;
    noStroke() ;
    fill( skinColour ) ;
    for( int k = 0 ; k < nbSections ; ++k ){
      vertex( sections[k].hd.x -sin(sections[k].agl)*sections[k].weight/2 , sections[k].hd.y +cos(sections[k].agl)*sections[k].weight/2) ;
    }
    for( int k = nbSections-1 ; k >=0 ; --k ){
      vertex( sections[k].hd.x +sin(sections[k].agl)*sections[k].weight/2 , sections[k].hd.y -cos(sections[k].agl)*sections[k].weight/2) ;
    }
    endShape(CLOSE) ;
    //Fin
    int kFin = int(0.45*nbSections) ;
    fin.scale(-1,-1) ;
    fin.translate(0,-0.9*sections[kFin].weight) ;
    pushMatrix() ;
    translate( sections[kFin].tl.x , sections[kFin].hd.y-1*sections[kFin].weight/2 ) ;
    rotate(sections[kFin].agl) ;
    shape( fin , 0 , 0 ) ;
    popMatrix() ;
    fin.resetMatrix() ;
    //Tail
    tail.rotate( sections[nbSections-1].agl ) ;
    shape( tail , sections[nbSections-1].hd.x , sections[nbSections-1].hd.y ) ;
    tail.resetMatrix() ;
    //Head
    head.rotate( sections[0].agl ) ;
    shape( head , sections[0].hd.x , sections[0].hd.y ) ;
    head.resetMatrix() ;
    popMatrix() ;
  }
  
  float trajectory( float x ){
    return coefDom*sq(x-xMeet)+yMeet ;
  }
  
  void update(){
    float x = xSpeed*(frameCount-t0 -tMeeting) + xMeet ;
    float y = height-trajectory(x) ;
    moveTo(x,y) ;
    show() ;
  }
}

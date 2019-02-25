class Section{
  PShape shape ;
  float length ;
  PVector hd ;
  PVector tl ;
  float agl ;
  
  Section( PShape s , float x , float y , float len , float initialAngle ){
    shape = s ;
    hd = new PVector(x,y) ;
    length = len ;
    agl = initialAngle ;
    tl = new PVector(x+len*cos(agl),y+len*sin(agl)) ;
  }
  
  void moveTo( float x , float y ){
    hd.set(x,y) ;
    agl = atan2( y-tl.y , x-tl.x ) ;
    tl.set( x - cos(agl)*length , y -length*sin(agl) ) ;
  }
  
  void show(){
    shape.rotate(agl) ;
    shape( shape , hd.x , hd.y ) ;
    shape.resetMatrix() ;
  }
  void show(float offsetAngle){
    shape.rotate(agl+offsetAngle) ;
    shape( shape , hd.x , hd.y ) ;
    shape.resetMatrix() ;
  }
}

class Icarus{
  boolean isFalling = false ;
  boolean isCaught = false ;
  //Head
  PShape head ;
  //Wings
  color colour ;
  float noiseSeed ;
  PVector pos ;
  PVector dir ;
  float rot = TAU*0.13 ;
  float wingsPuls = 0.055;
  float phase = random(TAU) ;
  float speed = 2.8 ;
  PShape wing ;
  PGraphics wingsTrans ;
  float wingsPos = 0.52 ;
  float wingXoffset = width*0.3 ;
  float wingYoffset = height*0.2 ;
  //Body
  float centerOfGravityPosRatio ;
  Section body ;
  float bodyLength ;
  float bodyWeight ;
  //Arms
  float armPos = 0.7 ;
  float armLength ;
  float armWeight ;
  Section rightArm ;
  Section leftArm ;
  float offsetAngleArms ;
  float armPuls ;
  float armAmplitude ;
  //Legs
  float legPos = 0.2 ;
  float legLength ;
  float legWeight ;
  Section rightLeg ;
  Section leftLeg ;
  float offsetAngleLegs ;
  float legPuls ;
  float legAmplitude ;
  //Head
  float headRadius = 12 ;
  float smileBeginAngle = TAU *0.25*0.6 ;
  float minSmileRadius = headRadius*0.3 ;
  float smileEndAngle = smileBeginAngle ;
    //Eye
  float eyePosRadius = headRadius *0.6 ;
  float eyePosAngle = -TAU*0.25 *0.25 ;
  float eyeRadius = headRadius *0.2 ;
  //Fall
  float x0 , y0 , v0x , v0y ;
  float t0 ;
  //Air bubbles
  int nbBubblesPack = 0 ;
  
  Icarus( float x , float y , float z ){
    
    //Head
    head = createShape(GROUP) ;
      //Back
    PShape backHead = createShape( ELLIPSE , 0 , 0 , 2*headRadius , 2*headRadius ) ;
    backHead.setStroke(false) ;
    backHead.setFill( #FAEA5B ) ;
    head.addChild( backHead ) ;
      //Smile
    PShape smile = createShape() ;
    smile.beginShape() ;
    smile.stroke(0) ;
    smile.noFill() ;
    smile.vertex( headRadius*cos(smileBeginAngle) , headRadius*sin(smileBeginAngle) ) ;
    smile.quadraticVertex( headRadius*cos(smileBeginAngle) -2 , headRadius*sin(smileBeginAngle)+2 , minSmileRadius*cos(smileEndAngle) , minSmileRadius*cos(smileEndAngle) ) ;
    smile.endShape() ;
    head.addChild(smile) ;
      //Eye
    PShape white = createShape( ELLIPSE , eyePosRadius*cos(eyePosAngle) , eyePosRadius*sin(eyePosAngle) , 2*eyeRadius , 2*eyeRadius ) ;
    white.setStroke(false) ;
    white.setFill(color(255)) ;
    head.addChild( white ) ;
    //Wings
    wingsTrans = createGraphics(width,height,P3D) ;
    noiseSeed = random(1000) ;
    colour = color(255,255,255) ;
    wing = wing( 100 , colour ) ;
    //Body
    bodyLength = 100 ;
    pos = new PVector( x , y-bodyLength , z ) ;
    centerOfGravityPosRatio = 0.33 ;
    bodyWeight = 0.2*bodyLength ;
    PShape bodyShape = createShape( RECT , -bodyLength , -bodyWeight/2 , bodyLength , bodyWeight ) ;
    bodyShape.setStroke(false) ;
    bodyShape.setFill( #AAA4A0 ) ;
    body = new Section( bodyShape , x , y , bodyLength , TAU/4 ) ;
    //Arm
    offsetAngleArms = 0 ;
    armPuls = 0.065 ;
    armAmplitude=TAU*0.025 ;
    armLength = 35 ;
    armWeight = 0.2*armLength ;
    color tShirtColour = color(#AAA4A0) ;
    PShape armShape = createShape(GROUP) ;
    PShape skinArmShape = createShape( RECT , -armLength , -armWeight/2 , armLength , armWeight ) ;
    skinArmShape.setStroke(false) ;
    skinArmShape.setFill( #FAEA5B ) ;
    armShape.addChild( skinArmShape ) ;
    PShape tShirtArmShape = createShape( RECT , -armLength*0.8 , -armWeight/2 , armLength*0.8 , armWeight ) ;
    tShirtArmShape.setStroke(false) ;
    tShirtArmShape.setFill( tShirtColour ) ;
    armShape.addChild( tShirtArmShape ) ;
    rightArm = new Section( armShape , body.hd.x*armPos + body.tl.x*(1-armPos) , body.hd.y*armPos + body.tl.y*(1-armPos) , armLength, TAU/4 ) ;
    //PShape leftArmShape = createShape( RECT , -armLength , -armWeight/2 , armLength , armWeight ) ;
    //leftArmShape.setStroke(false) ;
    //leftArmShape.setFill( #FAEA5B ) ;
    leftArm = new Section( armShape , body.hd.x*armPos + body.tl.x*(1-armPos) , body.hd.y*armPos + body.tl.y*(1-armPos) , armLength, -TAU/4 ) ;
    //Leg
    offsetAngleLegs = 0 ;
    legPuls = 0.065 ;
    legAmplitude=TAU*0.03 ;
    legLength = 45 ;
    legWeight = 0.2*legLength ;
    PShape rightLegShape = createShape( RECT , -legLength , -legWeight/2 , legLength , legWeight ) ;
    rightLegShape.setStroke(false) ;
    rightLegShape.setFill( #8E4C22 ) ;
    rightLeg = new Section( rightLegShape , body.hd.x*legPos + body.tl.x*(1-legPos) , body.hd.y*legPos + body.tl.y*(1-legPos) , legLength, TAU/4 ) ;
    PShape leftLegShape = createShape( RECT , -legLength , -legWeight/2 , legLength , legWeight ) ;
    leftLegShape.setStroke(false) ;
    leftLegShape.setFill( #8E4C22 ) ;
    leftLeg = new Section( leftLegShape , body.hd.x*legPos + body.tl.x*(1-legPos) , body.hd.y*legPos + body.tl.y*(1-legPos) , legLength, -TAU/4 ) ;
  }
  
  float wingsTransparency( float dist ){
    if( dist < distStartMelting ){
      return map( dist, distStartMelting, minDistToSun , 1 , 0 ) ;
    }
    else {
      return 1 ;
    }
  }
  
  void show(){
    //Body
    leftArm.show(offsetAngleArms) ;
    leftLeg.show(-offsetAngleLegs) ;
    body.show() ;
    rightArm.show(-offsetAngleArms) ;
    rightLeg.show(offsetAngleLegs) ;
    //Head
    head.rotate(body.agl) ;
    shape(head, body.hd.x, body.hd.y) ;
    head.resetMatrix() ;
    //Wings
    if( !isFalling ) {
      wingsTrans.beginDraw() ;
      wingsTrans.clear() ;
      float xCam = width*0.5 ;
      float yCam = height * 0.5 ;
      wingsTrans.camera(xCam, yCam, (yCam) / tan(PI*30.0 / 180.0),xCam, yCam, 0, 0, 1, 0) ;
      wingsTrans.pushMatrix() ;
      wingsTrans.translate(wingXoffset,wingYoffset) ;
      wingsTrans.rotateX(TAU*0.15) ;
      wingsTrans.pushMatrix() ;
      float aglRot = TAU*0.3 *sin(frameCount*wingsPuls)/2 ;
      wingsTrans.rotateY( aglRot ) ;
      wingsTrans.shape(wing,0,0) ;
      wingsTrans.popMatrix() ;
      wingsTrans.rotateY( -aglRot ) ;
      wing.scale(-1,1) ;
      wingsTrans.shape(wing,0,0) ;
      wing.resetMatrix() ;
      wingsTrans.popMatrix() ;
      wingsTrans.endDraw() ;
      float alpha = wingsTransparency( pos.dist(sunPosition) ) ;
      imageBlend( wingsTrans , body.hd.x *wingsPos + body.tl.x *(1-wingsPos) -wingXoffset , body.hd.y *wingsPos + body.tl.y *(1-wingsPos) -wingYoffset , alpha ) ;
      if( alpha <= 0 ){
        isFalling = true ;
        x0 = pos.x ;
        y0 = pos.y ;
        v0x = dir.x ;
        v0y = dir.y ;
        t0 = frameCount ;
        shark = new Shark( width,height,frameCount , x0 , y0 , v0x , -v0y ) ;
        legPuls *= 5 ;
        legAmplitude *=1.5 ;
        armPuls *= 1 ;
        armAmplitude =3*TAU ;
      }
    }
    if( body.hd.y > height && frameCount%2==0 && nbBubblesPack < 2 ){
      for( int k = 0 ; k < 3 -nbBubblesPack ; ++k ){
        airBubbles.add( new AirBubble(body.hd.x+random(-4,4),body.hd.y+random(-4,4)) ) ;
      }
      nbBubblesPack++ ;
    }
  }
  
  void moveTo( PVector target ){
    //Body
    body.moveTo( target.x , target.y ) ;
    //Arm
    leftArm.moveTo( body.hd.x*armPos + body.tl.x*(1-armPos) , body.hd.y*armPos + body.tl.y*(1-armPos) ) ;
    rightArm.moveTo( body.hd.x*armPos + body.tl.x*(1-armPos) , body.hd.y*armPos + body.tl.y*(1-armPos) ) ;
    offsetAngleArms = armAmplitude * sin(frameCount*armPuls+1) ;
    //Leg
    leftLeg.moveTo( body.hd.x*legPos + body.tl.x*(1-legPos) , body.hd.y*legPos + body.tl.y*(1-legPos) ) ;
    rightLeg.moveTo( body.hd.x*legPos + body.tl.x*(1-legPos) , body.hd.y*legPos + body.tl.y*(1-legPos) ) ;
    offsetAngleLegs = legAmplitude * sin(frameCount*legPuls) ;
  }
  
  void moveTowards( PVector target ){
    dir = PVector.sub( target , pos ) ;
    dir.setMag( speed ) ;
    pos.add(dir) ;
    moveTo( pos ) ;
  }
  
  void fall(){
    float t = frameCount-t0 ;
    float x = v0x*t + x0 ;
    float y = grav*sq(t)/2 + v0y*t+y0 ;
    pos.set(x,y) ;
    moveTo( pos ) ;
    if( t > shark.tMeeting ){
      isCaught = true ;
    }
  }
  
  void draggedByShark(){
    moveTo( new PVector( shark.sections[0].hd.x , height - shark.sections[0].hd.y ) ) ;
    show() ;
  }
}

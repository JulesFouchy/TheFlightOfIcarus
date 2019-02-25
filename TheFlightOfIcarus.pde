//import processing.sound.*;
//SoundFile file;

PGraphics background ;
PGraphics sea ;
float ySea ;
Scum scum ;
PShape waveCrest ;
float wavesPosVar = 12 ;
Icarus icarus ;
Shark shark ;
boolean isLooping = false ;
float initialDistToSun ;
PVector sunPosition ;
float grav = 0.735 ;
PVector gravity = new PVector( 0,grav ) ;
ArrayList<AirBubble> airBubbles ;

float distStartMelting = 650 ;
float minDistToSun = 150 ;

color seaColour = #1C35AD ;

void setup(){
  //file = new SoundFile(this, "titanic.mp3");
  //file.play();
  fullScreen( P3D ) ;
  frameRate(25) ;
  //Background
  background = createGraphics( width , height ) ;
  background.beginDraw() ;
  background.background(#57CCF5) ;
  for( int k = 0 ; k < 3 ; ++k ){
    mountain( background , 0 , width*(0.33+random(-0.1,0.1)), height*0.85 , 500 , 300 ) ;
  }
    //Sun
  sunPosition = new PVector( width*0.8 , height*0.1 ) ;
  sun( background , sunPosition.x , sunPosition.y ) ;
  //Sea
  ySea = height*0.65 ;
  sea = createGraphics( width , height ) ;
  sea.beginDraw() ;
  sea.noStroke() ;
  sea.fill( seaColour ) ;
  sea.rect( 0 , ySea , width , height-ySea ) ;
  sea.endDraw() ;
  //Scum
  scum = new Scum(ySea) ;
  //Waves
  waveCrest = waveCrest( 80 , 67 , -40 ) ;
  background.endDraw() ;
  //Air Bubbles
  airBubbles = new ArrayList<AirBubble>() ;
  
  image(background,0,0) ;
  
}

void draw(){
  if( isLooping ){
    //Background
    image(background,0,0) ;
    //Icarus
    icarus.show() ;
    if( !icarus.isFalling ){
      icarus.moveTowards(sunPosition) ;
    }
    else{
      shark.update() ;
      if(!icarus.isCaught) {
        icarus.fall() ;
      }
      else{
        icarus.draggedByShark() ;
      }
    }
    //Sea
    image( sea , 0 , 0 ) ;
    //Scum
    scum.update() ;  
    //Waves
    float wavesPuls = 0.022 ;
    int nbWaves = 7 ;
    float widthForWaves = width*1.4 ;
    for( int k = 0 ; k < nbWaves ; ++k ){
      shape( waveCrest , (k*widthForWaves/nbWaves+frameCount)%widthForWaves-(widthForWaves-width)/2 , ySea*1.03 + wavesPosVar*(1+sin(frameCount*wavesPuls+k*0+TAU*noise(frameCount*0.001)) ) ) ;
    }
    //Air Bubbles
    for( int k = airBubbles.size()-1 ; k>=0 ; --k ){
      AirBubble airBubble = airBubbles.get(k) ;
      airBubble.update() ;
      if( airBubble.pos.y < ySea ){
        airBubbles.remove(k) ;
      }
    }
    //saveFrame("film/####.tiff") ;
  }
}

void mousePressed(){
  cave( background , mouseX , mouseY ) ;
  //Icarus
  initialDistToSun = sqrt( sq(mouseX-sunPosition.x) + sq(mouseY-sunPosition.y) ) ;
  icarus = new Icarus( mouseX , mouseY , 50 ) ;
  isLooping = true ;
}

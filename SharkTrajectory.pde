float calculateTmeeting( float v0x , float xMeet , float x0 ){
  return (xMeet-x0)/v0x ;
}

float calculateXmeeting( float yMeet , float x0 , float v0x , float v0y ){
  float a = grav/2/sq(v0x) ;
  float b = v0y/v0x; 
  float c = -yMeet ;
  float delta = sq(b) - 4*a*c ;
  return max( (-b-sqrt(delta))/2/a , (-b+sqrt(delta))/2/a ) + x0 ;
}

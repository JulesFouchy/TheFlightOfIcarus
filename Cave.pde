void cave( PGraphics pg , float x , float y ){
  background.beginDraw() ;
  background.fill(0) ;
  background.noStroke() ;
  background.ellipse(x,y,40,30) ;
  background.endDraw() ;
  //pg.beginDraw() ;
  //ellipseGradient( pg , int(x) , int(y) , 40 , 30 , color(#CE7200) , color(0) ) ;
  //pg.endDraw() ;
}

//color ellipseGradientColour( float t ){
//  return t<0.25 ? lerpColor( , ) : 0
//}

//void ellipseGradient( PGraphics pg , int x0 , int y0 , int a , int b ){
//  pg.noStroke() ;
//  pg.fill( colour2 ) ;
//  pg.ellipse( x0 , y0 , a , b ) ;
//  pg.loadPixels() ;
//  for( int x = x0-a/2 ; x <= x0+a/2 ; ++x ){
//    for( int y = y0-b/2 ; y <= y0+b/2 ; ++y ){
//      float r = sqrt( sq(x-x0) + sq((y-y0)*a/b) ) ;
//      if( r < a/2 ){
//        pg.pixels[y*pg.width+x] = ellipseGradientColour( r/a*2 ) ;
//      }
//    }
//  }
//  pg.updatePixels() ;
//}

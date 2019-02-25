float modulo( float x , float m ){
  while( x < 0 ){
    x += m ;
  }
  while( x > m ){
    x -= m ;
  }
  return x ;
}

void imageBlend( PGraphics pg , float x_ , float y_ , float alpha ){
  int x = int(x_) ;
  int y = int(y_) ;
  loadPixels() ;
  pg.loadPixels() ;
  for( int j = x ; j < width ; ++j ){
    for( int i = y ; i < height ; ++i ){
      if( (i-y)*width+(j-x) < pg.pixels.length && (i-y)*width+(j-x)>=0 && alpha(pg.pixels[(i-y)*width+(j-x)]) > 0 && i*width+j <pixels.length && i*width+j >=0 ){
        int R = int( alpha*red(pg.pixels[(i-y)*width+(j-x)]) + (1-alpha)*red(pixels[i*width+j]) ) ;
        int G = int( alpha*green(pg.pixels[(i-y)*width+(j-x)]) + (1-alpha)*green(pixels[i*width+j]) ) ;
        int B = int( alpha*blue(pg.pixels[(i-y)*width+(j-x)]) + (1-alpha)*blue(pixels[i*width+j]) ) ;
        pixels[i*width+j] = color(R,G,B) ;
      }
    }
  }
  updatePixels() ;
}

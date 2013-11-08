part of pixi;


class Ellipse
{
  num x;
  num y;
  num width;
  num height;
  
  Ellipse(this.x, this.y, this.width, this.height);
  Ellipse.empty() : this(0, 0, 0, 0);
  
  Ellipse clone()
  {
    return new Ellipse(this.x, this.y, this.width, this.height);
  }
  
  bool contains(num x, num y)
  {
    if(this.width <= 0 || this.height <= 0)
        return false;

    //normalize the coords to an ellipse with center 0,0
    //and a radius of 0.5
    var normx = ((x - this.x) / this.width) - 0.5,
        normy = ((y - this.y) / this.height) - 0.5;

    normx *= normx;
    normy *= normy;

    return (normx + normy < 0.25);
  }
  
  PixiRectangle getBounds()
  {
    return new PixiRectangle(this.x, this.y, this.width, this.height);
  }
}
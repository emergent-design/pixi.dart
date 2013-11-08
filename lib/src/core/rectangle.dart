part of pixi;


class PixiRectangle
{
  num x;
  num y;
  num width;
  num height;
  
  PixiRectangle(this.x, this.y, this.width, this.height);
  PixiRectangle.empty() : this(0, 0, 0, 0);
  
  PixiRectangle clone()
  {
    return new PixiRectangle(this.x, this.y, this.width, this.height);
  }
  
  bool contains(num x, num y)
  {
    if(this.width <= 0 || this.height <= 0)
        return false;

    var x1 = this.x;
    if(x >= x1 && x <= x1 + this.width)
    {
      var y1 = this.y;
      
      if(y >= y1 && y <= y1 + this.height)
      {
        return true;
      }
    }

    return false;
  }
}
part of pixi;


class Circle
{
  num x;
  num y;
  num radius;
  
  Circle(this.x, this.y, this.radius);
  Circle.empty() : this(0, 0, 0);
  
  Circle clone()
  {
    return new Circle(this.x, this.y, this.radius);
  }
  
  bool contains(num x, num y)
  {
    if(this.radius <= 0)
      return false;

    var dx = (this.x - x),
        dy = (this.y - y),
        r2 = this.radius * this.radius;

    dx *= dx;
    dy *= dy;

    return (dx + dy <= r2);
  } 
}
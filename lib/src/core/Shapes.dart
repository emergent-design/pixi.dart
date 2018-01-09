part of pixi.core;

@JS()
@anonymous
class Shape
{
	external num get type;
	external bool contains(num x, num y);
}


@JS()
class Rectangle extends Shape
{
	external static Rectangle get EMPTY;

	external num get x;
	external set x(num value);

	external num get y;
	external set y(num value);

	external num get width;
	external set width(num value);

	external num get height;
	external set height(num value);

	external int get type;

	external num get left;
	external num get right;
	external num get top;
	external num get bottom;


	external Rectangle([num x, num y, num width, num height]);

	external Rectangle clone();
	external Rectangle copy(Rectangle rectangle);

	// external bool contains(num x, num y);
	external void pad(num paddingX, num paddingY);
	external void fit(Rectangle rectangle);
	external void enlarge(Rectangle rectangle);
}

@JS()
class Polygon extends Shape
{
	external List<num> get points;
	external set points(List<num> values);

	external Polygon(List<Point> points);
	external Polygon clone();
	external void close();
}


@JS()
class Circle extends Shape
{
	external num get x;
	external set x(num value);

	external num get y;
	external set y(num value);

	external num get radius;
	external set radius(num value);

	external Circle([ num x, num y, num radius ]);
	external Circle clone();
	external Rectangle getBounds();
}


@JS()
class Ellipse extends Shape
{
	external num get x;
	external set x(num value);

	external num get y;
	external set y(num value);

	external num get width;
	external set width(num value);

	external num get height;
	external set height(num value);

	external Ellipse([ num x, num y, num width, num height ]);
	external Ellipse clone();
	external Rectangle getBounds();
}


@JS()
class RoundedRectangle extends Shape
{
	external num get x;
	external set x(num value);

	external num get y;
	external set y(num value);

	external num get width;
	external set width(num value);

	external num get height;
	external set height(num value);

	external num get radius;
	external set radius(num value);

	external RoundedRectangle([ num x, num y, num width, num height, num radius ]);
	external RoundedRectangle clone();
}

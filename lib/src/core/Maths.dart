part of pixi.core;


@JS()
class Point
{
	external num get x;
	external set x(num value);

	external num get y;
	external set y(num value);

	external Point([num x = 0, num y = 0]);

	external Point clone();
	external void copy(Point p);
	external bool equals(Point p);
	external void set(num x, [ num y ]);
}


@JS()
class GroupD8
{
	external static num rotate180(num rotation);
	external static bool isVertical(num rotation);
	external static num byDirection(num dx, num dy);
}


@JS()
class Matrix
{
	external Matrix(num a, num b, num c, num d, num tx, num ty);

	external void fromArray(List<num> values);
	external Matrix set(num a, num b, num c, num d, num tx, num ty);
	external List<num> toArray(bool transpose, [ Float32List out ]);

	external Point apply(Point pos, [ Point newPos ]);
	external Point applyInverse(Point pos, [ Point newPos ]);

	external Matrix translate(num x, num y);
	external Matrix scale(num x, num y);
	external Matrix rotate(num angle);
	external Matrix append(Matrix matrix);
	external Matrix setTransform(num x, num y, num pivotX, num pivotY, num scaleX, num scaleY, num rotation, num skewX, num skewY);
	external Matrix prepend(Matrix matrix);
	external TransformStatic decomponse(TransformStatic transform);
	external Matrix invert();
	external Matrix identity();
	external Matrix clone();
	external Matrix copy(Matrix matrix);

	external static Matrix get IDENTITY;
	external static Matrix get TEMP_MATRIX;
}
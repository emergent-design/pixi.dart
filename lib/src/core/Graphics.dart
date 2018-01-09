part of pixi.core;


@JS()
class Graphics extends Container
{
	external int get blendMode;
	external set blendMode(int value);

	external num get boundsPadding;
	external set boundsPadding(num value);

	external num get fillAlpha;
	external set fillAlpha(num value);

	external bool get isMask;
	external set isMask(bool value);

	external String get lineColor;
	external set lineColor(String value);

	external num get lineWidth;
	external set lineWidth(num value);

	external bool get nativeLines;
	external set nativeLines(bool value);

	external num get tint;
	external set tint(num value);


	external Graphics();

	external Graphics addHole();
	external Graphics arc(num cx, num cy, num radius, num startAngle, num endAngle, [ bool anticlockwise ]);
	external Graphics arcTo(num x1, num y1, num x2, num y2, num radius);
	external Graphics beginFill(num color, [ num alpha ]);
	external Graphics bezierCurveTo(num cpX, num cpY, num cpX2, num cpY2, num toX, num toY);
	external Graphics clear();
	external Graphics clone();
	external Graphics closePath();
	external Graphics drawCircle(num x, num y, num radius);
	external Graphics drawEllipse(num x, num y, num width, num height);
	external Graphics drawPolygon(List<Point> path);
	external Graphics drawRect(num x, num y, num width, num height);
	external Graphics drawRoundedRect(num x, num y, num width, num height, num radius);
	external GraphicsData drawShape(Shape shape);
	external Graphics endFill();
	external Graphics lineStyle(num lineWidth, [num color, num alpha ]);
	external Graphics lineTo(num x, num y);
	external Graphics moveTo(num x, num y);
	external Graphics quadraticCurveTo(num cpX, num cpY, num toX, num toY);

	external Texture generateCanvasTexture(num scaleMode, [ num resolution ]);
	external bool isFastRect();
	external bool containsPoint(Point point);
	external void updateLocalBounds();
}


@JS()
class GraphicsData
{
	external num get lineWidth;
	external set lineWidth(num value);

	external num get lineColor;
	external set lineColor(num value);

	external num get lineAlpha;
	external set lineAlpha(num value);

	external num get fillColor;
	external set fillColor(num value);

	external num get fillAlpha;
	external set fillAlpha(num value);

	external bool get fill;
	external set fill(bool value);

	external bool get nativeLines;
	external set nativeLines(bool value);

	external Shape get shape;
	external set shape(Shape value);

	external num get type;

	external GraphicsData(num lineWidth, num lineColor, num lineAlpha, num fillColor, num fillAlpha, bool fill, Shape shape);

	external void addHole(Shape shape);
	external GraphicsData clone();
	external void destroy();
}

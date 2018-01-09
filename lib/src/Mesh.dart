@JS('PIXI.mesh')
library pixi.mesh;

import 'dart:typed_data';
import 'package:js/js.dart';
import 'Core.dart';



@JS()
class Mesh extends Container
{
	external int get blendMode;
	external set blendMode(int value);

	external num get canvasPadding;
	external set canvasPadding(num value);

	external int get drawMode;
	external set drawMode(int value);

	external Texture get texture;
	external set texture(Texture value);

	external Uint16List get indices;
	external set indices(Uint16List value);

	external Float32List get uvs;
	external set uvs(Float32List value);

	external Float32List get vertices;
	external set vertices(Float32List value);

	external num get tint;
	external set tint(num value);


	external Mesh([Texture texture, Float32List vertices, Float32List uvs, Uint16List indices, int drawMode]);

	external bool containsPoint(Point point);

}


@JS()
class Rope extends Mesh
{
	external Rope(Texture texture, List<Point> points);
}


@JS()
class Plane extends Mesh
{
	external Plane(Texture texture, List<num> verticesX, List<num> verticesY );
}


@JS()
class NineSlicePlane extends Mesh
{
	external NineSlicePlane(Texture texture, [ num leftWidth, num topHeight, num rightWidth, num bottomHeight ]);
}
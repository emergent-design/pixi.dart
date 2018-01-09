part of pixi.core;


@JS()
class Sprite extends Container
{
	external Sprite([Texture texture]);

	external static Sprite fromImage(String imageId);
	external static Sprite fromFrame(String frameId);

	external int get blendMode;
	external set blendMode(int value);

	external Point get anchor;
	external set anchor(Point value);

	external String get pluginName;
	external set pluginName(String value);

	external Shader get shader;
	external set shader(Shader shader);

	external Texture get texture;
	external set texture(Texture value);

	external num get tint;
	external set tint(num value);

	external bool containsPoint(Point point);
}

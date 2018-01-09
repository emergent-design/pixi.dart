part of pixi.extras;


@JS()
class TilingSprite extends Sprite
{
	external Point get tilePosition;
	external set tilePosition(Point value);

	external Point get tileScale;
	external set tileScale(Point value);


	external TilingSprite(Texture texture, [num width, num height]);

	external bool containsPoint(Point point);
}

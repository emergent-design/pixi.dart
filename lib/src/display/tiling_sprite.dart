part of pixi;


class TilingSprite extends Sprite
{
	Point<double> tileScale		= new Point(1.0, 1.0);
	Point<double> tilePosition	= new Point(0.0, 0.0);
	CanvasPattern __tilePattern	= null;


	TilingSprite(Texture texture, { num width: 0, num height: 0 }) : super(texture, width: width, height: height);


	void _initialise()
	{
		this.scale = new Point(1.0, 1.0);
		this._texture._frame = new Rectangle(0, 0, this._width, this._height);
	}


	void set width(num value)
	{
		this._width	= value;
		this._texture._frame = new Rectangle(0, 0, this._width, this._height);
	}


	void set height(num value)
	{
		this._height = value;
		this._texture._frame = new Rectangle(0, 0, this._width, this._height);
	}


	void _render(Renderer renderer)
	{
		renderer._renderTilingSprite(this);
	}
}

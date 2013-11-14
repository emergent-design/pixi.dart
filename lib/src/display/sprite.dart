part of pixi;


class Sprite extends DisplayObject
{
	// Blending modes
	static const NORMAL = 0;
	static const SCREEN = 1;

	Point anchor		= new Point(0, 0);
	int blendMode		= NORMAL;
	num _width			= 0;
	num _height			= 0;
	bool _textureChange = false;
	Texture _texture	= null;
	Texture get texture => this._texture;


	Sprite(this._texture, { num width: 0, num height: 0 })
	{
		this._width		= width;
		this._height	= height;

		if (this._texture != null)
		{
			if (!this._texture.hasLoaded)
			{
				this._texture.onLoaded.listen((i) => this._initialise());
			}
			else this._initialise();
		}
	}


	void _initialise()
	{
		var x = this._scale.x;
		var y = this._scale.y;

		if (this._width > 0) 	x = this._width / this._texture.frame.width;
		if (this._height > 0)	y = this._height / this._texture.frame.height;

		this._scale	= new Point(x, y);
	}


	void _render(Renderer renderer)
	{
		renderer._renderSprite(this);
	}


	num get width => this._scale.x * this._texture.frame.width;
	void set width(num value)
	{
		this._scale	= new Point(value / this._texture.frame.width, this._scale.y);
		this._width	= value;
	}

	num get height => this._scale.y * this._texture.frame.height;
	void set height(num value)
	{
		this._scale 	= new Point(this._scale.x, value / this._texture.frame.height);
		this._height	= value;
	}


	void setTexture(Texture texture)
	{
		if (this._texture == null || this._texture._base != texture._base)
		{
			this._textureChange = true;
		}

		this._texture = texture;
	}


	factory Sprite.fromImage(String imageUrl)
	{
		return new Sprite(new Texture.fromImage(imageUrl));
	}


	factory Sprite.fromFrame(String frameId)
	{
		return new Sprite(new Texture.fromFrame(frameId));
	}
}

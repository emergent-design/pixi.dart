part of pixi;


class Sprite extends DisplayObject
{
	// Blending modes
	static const NORMAL = 0;
	static const SCREEN = 1;

	Point anchor		= new Point(0, 0);
	int blendMode		= NORMAL;
	WebGLBatch __batch	= null;
	_SpriteLink __link	= null;
	num _width			= 0;
	num _height			= 0;
	bool _updateFrame	= false;
	bool _textureChange = false;

	Texture _texture	= null;
	Texture get texture => this._texture;


	Sprite(this._texture)
	{
		this._renderable = true;

		if (this._texture != null)
		{
			if (this._texture.hasLoaded)
			{
				this._updateFrame = true;
			}
			else this._texture.onLoaded.listen((i) {
				var x = this.scale.x;
				var y = this.scale.y;

				if (this._width > 0) 	x = this._width / this._texture.frame.width;
				if (this._height > 0)	y = this._height / this._texture.frame.height;

				this.scale			= new Point(x, y);
				this._updateFrame	= true;
			});
		}
	}


	num get width => this.scale.x * this._texture.frame.width;
	void set width(num value)
	{
		this.scale	= new Point(value / this._texture.frame.width, this.scale.y);
		this._width	= value;
	}

	num get height => this.scale.y * this._texture.frame.height;
	void set height(num value)
	{
		this.scale 		= new Point(this.scale.x, value / this._texture.frame.height);
		this._height	= value;
	}


	void setTexture(Texture texture)
	{
		if (this._texture == null || this._texture._base != texture._base)
		{
			this._textureChange = true;

			if (this.__group != null) this.__group._updateTexture(this);
		}

		this._texture		= texture;
		this._updateFrame	= true;
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

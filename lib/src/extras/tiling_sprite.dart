part of pixi;


class TilingSprite extends DisplayObject //with _WebGLData
{
	Texture _texture;
	int _width;
	int _height;
	bool _updateFrame			= true;
	int blendMode				= Sprite.NORMAL;
	Point<double> tileScale		= new Point(1.0, 1.0);
	Point<double> tilePosition	= new Point(0.0, 0.0);
	CanvasPattern __tilePattern	= null;


	TilingSprite(this._texture, this._width, this._height)
	{
		//this._renderable = true;
	}


	void setTexture(Texture texture)
	{
		this._texture		= texture;
		this._updateFrame 	= true;
	}


	void _render(Renderer renderer)
	{
		renderer._renderTilingSprite(this);
	}

	//void onTextureUpdate ??
	//{
	//	this._updateFrame = true;
	//}
}

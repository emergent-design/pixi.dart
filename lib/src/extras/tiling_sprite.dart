part of pixi;


class TilingSprite extends DisplayObject with _WebGLData
{
	Texture _texture;
	int _width;
	int _height;
	bool _updateFrame			= true;
	int blendMode				= Sprite.NORMAL;
	Point<double> tileScale		= new Point(1.0, 1.0);
	Point<double> tilePosition	= new Point(0.0, 0.0);
	CanvasPattern __tilePattern	= null;

	/*Float32List __vertices		= null;
	Float32List __uvs			= null;
	Float32List __colours		= null;
	Uint16List __indices		= null;
	GL.Buffer __vertexBuffer	= null;
	GL.Buffer __indexBuffer		= null;
	GL.Buffer __uvBuffer		= null;
	GL.Buffer __colourBuffer	= null;*/


	TilingSprite(this._texture, this._width, this._height)
	{
		this._renderable = true;
	}


	void setTexture(Texture texture)
	{
		this._texture		= texture;
		this._updateFrame 	= true;
	}

	//void onTextureUpdate ??
	//{
	//	this._updateFrame = true;
	//}
}

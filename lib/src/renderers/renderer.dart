part of pixi;


abstract class Renderer
{
	int _width;
	int _height;
	bool _transparent;
	CanvasElement _view;
	CanvasElement get view => this._view;


	Renderer(this._width, this._height, CanvasElement view, this._transparent)
	{
		this._view	= view != null ? view : new CanvasElement();
		this._view.width	= this._width;
		this._view.height	= this._height;
	}


	void resize(int width, int height)
	{
		this._view.width	= this._width	= width;
		this._view.height	= this._height	= height;
	}


	void render(Stage stage);

	void destroyTextures(Iterable<BaseTexture> textures)
	{
		for (var t in textures) t._destroy();
	}


	void _renderSprite(Sprite sprite);
	void _renderGraphics(Graphics graphics);
	void _renderTilingSprite(TilingSprite sprite);
}
part of pixi;


abstract class Renderer
{
	int _width;
	int _height;
	bool _transparent;
	CanvasElement _view;
	_InteractionManager _interaction;

	CanvasElement get view => this._view;


	Renderer(this._width, this._height, CanvasElement view, this._transparent, bool interactive)
	{
		this._view			= view != null ? view : new CanvasElement();
		this._interaction	= interactive ? new _InteractionManager(this, this._view) : null;
		this._view.width	= this._width;
		this._view.height	= this._height;
	}

	// Function to override interactive dom element?


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
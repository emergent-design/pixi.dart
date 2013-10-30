part of pixi;


class CanvasRenderer
{
	int _count							= 0;
	int _width							= 800;
	int _height							= 600;
	bool _transparent					= false;
	bool _refresh						= true;
	CanvasElement _view 				= null;
	CanvasRenderingContext2D _context	= null;

	CanvasElement get view => this._view;


	CanvasRenderer(this._width, this._height, [CanvasElement view = null, this._transparent = false])
	{
		this._view			= view != null ? view : new CanvasElement();
		this._context		= this._view.getContext("2d");
		this._view.width	= this._width;
		this._view.height	= this._height;
	}


	void render(Stage stage)
	{
		//texturesToUpdate??
		//texturesToDestroy??
		//visibleCount++??

		stage.updateTransform();

		if (this._view.style.backgroundColor != stage.backgroundColor && !this._transparent)
		{
			this._view.style.backgroundColor = stage.backgroundColor.html;
		}

		this._context.setTransform(1, 0, 0, 1, 0, 0);
		this._context.clearRect(0, 0, this._width, this._height);
		this._context.globalCompositeOperation = 'source-over';

		this._renderDisplayObject(stage);

		if (stage.interactive)
		{
			// TODO: ??
		}

		// remove frame updates..
		//if(PIXI.Texture.frameUpdates.length > 0)
		//{
		//	PIXI.Texture.frameUpdates = [];
		//}
	}


	void resize(int width, int height)
	{
		this._view.width	= this._width	= width;
		this._view.height	= this._height	= height;
	}


	void _renderDisplayObject(DisplayObject object)
	{
		if (!object.visible) return;

		var transform = object.worldTransform;

		if (object is DisplayObjectContainer)
		{
			for (var c in (object as DisplayObjectContainer).children)
			{
				this._renderDisplayObject(c);
			}
		}
		else if (object.renderable)
		{
			if (object is Graphics)
			{
				this._context.setTransform(transform[0], transform[3], transform[1], transform[4], transform[2], transform[5]);
				_CanvasGraphics.renderGraphics(object, this._context);
			}
			else if (object is Sprite)
			{
				var sprite	= object as Sprite;
				var frame	= sprite.texture.frame;

				if (frame != null)
				{
					this._context.globalAlpha = sprite.worldAlpha;
					this._context.setTransform(transform[0], transform[3], transform[1], transform[4], transform[2], transform[5]);
					this._context.drawImageToRect(
						sprite.texture.source,
						new Rectangle((sprite.anchor.x) * (-frame.width), (sprite.anchor.y) * (-frame.height), frame.width, frame.height),
						sourceRect: frame
					);
				}
			}
			//else if (object is Strip)
			//else if (object is TilingSprite)
			//else if (object is CustomRenderable)
			//else if (object is FilterBlock)
		}
	}
}


part of pixi;


class CanvasRenderer extends Renderer
{
	CanvasRenderingContext2D _context	= null;


	CanvasRenderer({int width: 800, int height: 600, CanvasElement view: null, bool transparent: false }) : super(width, height, view, transparent)
	{
		this._context = this._view.getContext("2d");
	}


	void render(Stage stage)
	{
		BaseTexture._toUpdate.clear();
		BaseTexture._toDestroy.clear();
		//texturesToUpdate??
		//texturesToDestroy??
		//visibleCount++??

		DisplayObject._visibleCount++;
		stage.updateTransform();

		if (this._view.style.backgroundColor != stage.backgroundColor && !this._transparent)
		{
			this._view.style.backgroundColor = stage.backgroundColor.html;
		}

		this._context.setTransform(1, 0, 0, 1, 0, 0);
		this._context.clearRect(0, 0, this._width, this._height);
		this._context.globalCompositeOperation = 'source-over';

		for (var object in stage._list)
		{
			this._renderDisplayObject(object);
		}
		//this._renderDisplayObject(stage);

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


	void _renderDisplayObject(DisplayObject object)
	{
		//if (!object.visible) return;



		//if (object is DisplayObjectContainer)
		//{
			//for (var c in object.children)
			//{
			//	this._renderDisplayObject(c);
			//}
		//}
		//else
		if (object.visible && object.renderable)
		{
			var transform = object.worldTransform;

			if (object is Graphics)
			{
				this._context.setTransform(transform[0], transform[3], transform[1], transform[4], transform[2], transform[5]);
				_CanvasGraphics.renderGraphics(object, this._context);
			}
			else if (object is Sprite)
			{
				var frame = object.texture.frame;

				if (frame != null)
				{
					this._context.globalAlpha = object.worldAlpha;
					this._context.setTransform(transform[0], transform[3], transform[1], transform[4], transform[2], transform[5]);
					this._context.drawImageToRect(
						object.texture.source as CanvasImageSource,
						new Rectangle((object.anchor.x) * (-frame.width), (object.anchor.y) * (-frame.height), frame.width, frame.height),
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


part of pixi;


class CanvasRenderer extends Renderer
{
	CanvasRenderingContext2D _context	= null;


	CanvasRenderer({int width: 800, int height: 600, CanvasElement view: null, bool transparent: false }) : super(width, height, view, transparent)
	{
		this._context = this._view.context2D;
	}


	void render(Stage stage)
	{
		//BaseTexture._toUpdate.clear();
		//BaseTexture._toDestroy.clear();

		if (this._view.style.backgroundColor != stage.backgroundColor && !this._transparent)
		{
			this._view.style.backgroundColor = stage.backgroundColor.html;
		}

		this._context.setTransform(1, 0, 0, 1, 0, 0);
		this._context.clearRect(0, 0, this._width, this._height);
		this._context.globalCompositeOperation = 'source-over';


		stage._render(this);


		if (stage.interactive)
		{
			// TODO: ??
		}
	}


	void _renderGraphics(Graphics graphics)
	{
		var trans = graphics.worldTransform;

		this._context.setTransform(trans[0], trans[3], trans[1], trans[4], trans[2], trans[5]);
		_CanvasGraphics.renderGraphics(graphics, this._context);
	}


	void _renderSprite(Sprite sprite)
	{
		var frame	= sprite.texture.frame;
		var context	= this._context;
		var trans	= sprite.worldTransform;

		if (frame != null)
		{
			context.globalAlpha = sprite.worldAlpha;
			context.setTransform(trans[0], trans[3], trans[1], trans[4], trans[2], trans[5]);
			context.drawImageToRect(
				sprite.texture.source as CanvasImageSource,
				new Rectangle(
					(sprite.anchor.x) * (-frame.width),
					(sprite.anchor.y) * (-frame.height),
					frame.width,
					frame.height
				),
				sourceRect: frame
			);
		}
	}


	void _renderTilingSprite(TilingSprite sprite)
	{
		var context = this._context;
		var trans	= sprite.worldTransform;

		context.globalAlpha = sprite.worldAlpha;
		context.setTransform(trans[0], trans[3], trans[1], trans[4], trans[2], trans[5]);

		if (sprite.__tilePattern == null)
		{
			if (sprite._texture._base._source is ImageElement)
			{
				sprite.__tilePattern = context.createPatternFromImage(sprite._texture._base._source, "repeat");
			}
			else if (sprite._texture._base._source is CanvasElement)
			{
				sprite.__tilePattern = context.createPattern(sprite._texture._base._source, "repeat");
			}
		}

		context.beginPath();

		var position	= sprite.tilePosition;
		var scale		= sprite.tileScale;

		context.scale(scale.x, scale.y);
		context.translate(position.x, position.y);

		context.fillStyle = sprite.__tilePattern;
		context.fillRect(-position.x, -position.y, sprite._width / scale.x, sprite._height / scale.y);

		context.scale(1 / scale.x, 1 / scale.y);
		context.translate(-position.x, -position.y);

		context.closePath();
	}
}


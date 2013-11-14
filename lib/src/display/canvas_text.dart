part of pixi;


class Style
{
	static const LEFT 	= 0;
	static const CENTRE = 1;
	static const RIGHT	= 2;

	int align;
	String font;
	Colour fill;
	Colour stroke;
	num strokeThickness;
	bool wordWrap;
	num wordWrapWidth;


	Style({
		this.font: "bold 20pt Arial",
		this.align: LEFT,
		this.fill: const Colour(0, 0, 0),
		this.stroke: const Colour(0, 0, 0),
		this.strokeThickness: 0,
		this.wordWrap: false,
		this.wordWrapWidth: 100
	});
}

// TODO: Derive both text classes from an abstract base
// which share some of the word wrapping functionality?
class CanvasText extends Sprite
{
	static Map<String, int> _heights = {};

	CanvasElement _canvas 				= new CanvasElement();
	CanvasRenderingContext2D _context	= null;
	String _text						= " ";
	Style _style						= new Style();
	bool _dirtyText						= false;


	CanvasText(String text, Style style) : super(null)
	{
		this._context = this._canvas.getContext("2d");

		this.setTexture(new Texture.fromCanvas(this._canvas));

		this.setText(text);
		this.setStyle(style);

		this._updateText();
	}


	void setText(String text)
	{
		this._text	= text != null ? text : " ";
		this._dirtyText	= true;
	}


	void setStyle(Style style)
	{
		this._style = style;
		this._dirtyText	= true;
	}


	void _updateTransform(DisplayObject parent)
	{
		if (this._dirtyText)
		{
			this._updateText();
			this._dirtyText = false;
		}

		super._updateTransform(parent);
	}


	/*void destroy(bool destroyTexture)
	{
		if (destroyTexture) this._texture.destroy(true);
	}*/


	void _updateText()
	{
		this._context.font	= this._style.font;
		var outputText		= this._style.wordWrap ? this._wordWrap(this._text) : this._text;
		var lines			= outputText.split(new RegExp(r"(?:\r\n|\r|\n)"));

		int i;
		int count			= lines.length;
		List<double> widths = new List<double>(count);
		double maxWidth		= 0.0;

		for (i=0; i < count; i++)
		{
			widths[i] 	= this._context.measureText(lines[i]).width;
			maxWidth	= max(maxWidth, widths[i]);
		}

		int lineHeight 				= (this._getHeight(this._style.font) + this._style.strokeThickness).ceil();
		this._canvas.width 			= (maxWidth + this._style.strokeThickness).ceil();
		this._canvas.height			= lineHeight * count;
		this._context.fillStyle 	= this._style.fill != null ? this._style.fill.html : "";
		this._context.strokeStyle	= this._style.stroke != null ? this._style.stroke.html : "";
		this._context.lineWidth		= this._style.strokeThickness;
		this._context.font			= this._style.font;
		this._context.textBaseline	= 'top';

		for (i=0; i < count; i++)
		{
			int x = (this._style.strokeThickness / 2).ceil();
			int y = (this._style.strokeThickness / 2).ceil() + i * lineHeight;

			switch (this._style.align)
			{
				case Style.LEFT:	x = (this._style.strokeThickness / 2).ceil();	break;
				case Style.CENTRE:	x = (maxWidth - widths[i]).ceil();				break;
				case Style.RIGHT:	x = ((maxWidth - widths[i]) / 2).ceil();		break;
			}

			if (this._style.stroke != null && this._style.strokeThickness > 0)
			{
				this._context.strokeText(lines[i], x, y);
			}

			if (this._style.fill != null)
			{
				this._context.fillText(lines[i], x, y);
			}
		}

		this._updateTexture();
	}


	void _updateTexture()
	{
		this._texture._base._width	= this._canvas.width;
		this._texture._base._height	= this._canvas.height;
		this._texture._base._dirtyTexture = true;
		this._texture.setFrame(null);


		//BaseTexture._toUpdate.add(this._texture._base);
	}


	int _getHeight(String font)
	{
		if (!_heights.containsKey(font))
		{
			var dummy = new DivElement()
				..appendText('M')
				..style.font = font
				..style.position = 'absolute'
				..style.top			= '0'
				..style.left		= '0';

			document.body.children.add(dummy);

			_heights[font] = dummy.offsetHeight;

			document.body.children.remove(dummy);
		}

		return _heights[font];
	}


	String _wordWrap(String text)
	{
		StringBuffer buffer = new StringBuffer();
		var lines 			= text.split('\n');

		for (var line in lines)
		{
			buffer.writeAll(this._lineWrap(line), '\n');
		}

		return buffer.toString();
	}


	// This is a bit different to the pixi.js implementation since it
	// wraps whole words.
	List<String> _lineWrap(String line)
	{
		if (line.length < 1 || this._context.measureText(line).width <= this._style.wordWrapWidth)
		{
			return [ line ];
		}

		var result		= new List<String>();
		var words		= line.split(new RegExp(r'\s+'));
		String current	= "";

		for (var word in words)
		{
			if (this._context.measureText(current + ' ' + word).width > this._style.wordWrapWidth)
			{
				result.add(current);
				current = word;
			}
			else current += current.length == 0 ? word : ' ' + word;
		}

		if (current.length > 0) result.add(current);

		return result;
	}
}

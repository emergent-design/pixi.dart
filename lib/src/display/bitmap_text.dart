part of pixi;


class _CharData
{
	int xOffset;
	int yOffset;
	int xAdvance;
	Texture texture;

	Map<int, int> kerning = {};
}


class _Font
{
	String font;
	int size;
	int lineHeight;
	Map<int, _CharData> chars = {};
}

class _Char
{
	Texture texture;
	int line;
	int charCode;
	int x;
	int y;


	_Char(this.texture, this.line, this.charCode, this.x, this.y);
}


class BitmapText extends DisplayObjectContainer
{
	static Map<String, _Font> _fonts = {};

	String _text	= " ";
	Style _style	= new Style();
	bool _dirtyText	= false;

	String _fontFace;
	int _fontSize;

	num _width = 0;
	num get width => this._width;

	num _height = 0;
	num get height => this._height;


	BitmapText(String text, Style style)
	{
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
		var match = new RegExp(r".*?(\d+)px\s+(.+)").firstMatch(style.font);

		if (match != null)
		{
			this._fontFace 	= match.group(2);
			this._fontSize	= int.parse(match.group(1), radix: 10);

			if (!_fonts.containsKey(this._fontFace)) throw "BitmapText has no font available called $_fontFace";
		}
		else if (_fonts.containsKey(style.font))
		{
			this._fontFace = style.font;
			this._fontSize = _fonts[style.font].size;
		}
		else throw "Unable to parse font information since it must be in the format 'Arial' or '24px Arial'";

		this._style	= style;
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


	void _updateText()
	{
		var data 	= _fonts[this._fontFace];
		var lines	= this._text.split(new RegExp(r"(?:\r\n|\r|\n)"));

		if (data == null) throw "BitmapText has no font available called $_fontFace";

		int x 				= 0;
		int y 				= 0;
		int prev			= -1;
		int maxWidth		= 0;
		int i, c, count		= lines.length;
		double scale 		= this._fontSize.toDouble() / data.size.toDouble();
		List<int> widths	= new List<int>(count);
		List<int> offsets	= new List<int>(count);
		_CharData charData	= null;
		List<_Char> chars	= [];

		for (i=0; i<count; i++, prev=-1, x=0, y+=data.lineHeight)
		{
			for (c in lines[i].codeUnits)
			{
				charData = data.chars[c];

				if (charData != null)
				{
					if (charData.kerning.containsKey(prev)) x += charData.kerning[prev];

					chars.add(new _Char(charData.texture, i, c, x + charData.xOffset, y + charData.yOffset));

					x += charData.xAdvance;
					prev = c;
				}
			}

			widths[i] 	= x;
			maxWidth	= max(maxWidth, x);
		}

		for (i=0; i<count; i++)
		{
			switch (this._style.align)
			{
				case Style.LEFT:	offsets[i] = 0;										break;
				case Style.RIGHT:	offsets[i] = maxWidth - widths[i];					break;
				case Style.CENTRE:	offsets[i] = ((maxWidth - widths[i]) / 2).ceil();	break;
			}
		}

		this.children.clear();

		for (var char in chars)
		{
			this.children.add(new Sprite(char.texture)
				..position	= new Point(char.x + offsets[char.line], char.y) * scale
				..scale		= new Point(scale, scale)
			);
		}

		this._width		= maxWidth * scale;
		this._height	= y * scale;
	}
}


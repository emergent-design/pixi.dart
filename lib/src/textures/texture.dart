part of pixi;


class Texture
{
	static Map<String, Texture> _cache = {};

	//Point _trim			= new Point();
	BaseTexture _base;

	Element get source => this._base.source;

	Rectangle _frame = null;
	Rectangle get frame => this._frame;

	int _width = 1;
	int get width => this._width;

	int _height = 1;
	int get height => this._height;

	bool _hasLoaded = false;
	bool get hasLoaded => this._hasLoaded;

	StreamController _loadedController = new StreamController.broadcast();
	Stream get onLoaded => this._loadedController.stream;


	Texture(BaseTexture base, [ Rectangle frame = null ])
	{
		if (base is Texture)
		{
			this._base = (base as Texture)._base;
		}
		else this._base = base;

		if (this._base.hasLoaded)
		{
			this.setFrame(frame);
		}
		else this._base.onLoaded.listen((i) {
			this.setFrame(frame);
			this._loadedController.add('loaded');
		});
	}

	factory Texture.fromImage(String imageUrl, [bool crossorigin = false])
	{
		var result = _cache[imageUrl];

		return result != null ? result : _cache[imageUrl] = new Texture(new BaseTexture.fromImage(imageUrl, crossorigin));
	}

	factory Texture.fromFrame(String frameId)
	{
		if (!_cache.containsKey(frameId))
		{
			throw "The frameId '$frameId' does not exist in the texture cache";
		}

		return _cache[frameId];
	}


	factory Texture.fromCanvas(CanvasElement canvas)
	{
		return new Texture(new BaseTexture(canvas));
	}


	static void addTextureToCache(Texture texture, String id)
	{
		_cache[id] = texture;
	}


	static Texture removeTextureFromCache(String id)
	{
		return _cache.remove(id);
	}


	void setFrame(Rectangle frame)
	{
		this._frame		= frame != null ? frame : new Rectangle(0, 0, this._base.width, this._base.height);
		this._width		= this._frame.width;
		this._height	= this._frame.height;

		if (this._frame.left + this._frame.width > this._base.width || this._frame.top + this._frame.height > this._base.height)
		{
			throw "Texture error: frame does not fit inside the base texture dimensions";
		}

		this._hasLoaded = true;
	}
}



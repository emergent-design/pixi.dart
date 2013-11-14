part of pixi;


class BaseTexture
{
	static Map<String, BaseTexture> _baseCache	= {};

	int _width = 100;
	int get width => this._width;

	int _height = 100;
	int get height => this._height;

	bool _hasLoaded = false;
	bool get hasLoaded => this._hasLoaded;

	Element _source;
	Element get source => this._source;

	StreamController _loadedController = new StreamController.broadcast();
	Stream get onLoaded => this._loadedController.stream;

	bool _dirtyTexture = true;


	BaseTexture(Element source)
	{
		this._source = source;

		if (source is ImageElement)
		{
			if (source.complete)
			{
				this._hasLoaded 	= true;
				this._width			= source.width;
				this._height		= source.height;
			}
			else source.onLoad.listen((e) {
				this._hasLoaded = true;
				this._width		= source.width;
				this._height	= source.height;
				this._loadedController.add('loaded');
			});
		}
		else if (source is CanvasElement)
		{
			this._hasLoaded = true;
			this._width		= source.width;
			this._height	= source.height;
		}
		else this._source = null;
	}


	void _destroy()
	{
		if (this._source is ImageElement)
		{
			(this._source as ImageElement).src = null;
		}

		this._source = null;
	}


	factory BaseTexture.fromImage(String imageUrl, [bool crossorigin = false])
	{
		var result = _baseCache[imageUrl];

		if (result == null)
		{
			var image = new ImageElement();

			if (crossorigin) image.crossOrigin = '';

			image.src = imageUrl;

			_baseCache[imageUrl] = result = new BaseTexture(image);
		}

		return result;
	}
}

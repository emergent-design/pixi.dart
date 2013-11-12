part of pixi;


class Graphics extends DisplayObject
{
	num _lineWidth		= 0;
	double _lineAlpha	= 1.0;
	Colour _lineColor	= new Colour(0, 0, 0);
	double _fillAlpha 	= 1.0;
	Colour _fillColor	= new Colour(0, 0, 0);
	bool _filling		= false;
	_Path _path 		= new _Path(_Path.POLY, 0, new Colour(0, 0, 0), 1.0, 1.0, new Colour(0, 0, 0), false, []);
	bool _dirtyGraphics	= true;
	bool _dirtyClear	= false;
	List<_Path> _data;


	Graphics()
	{
		this._data = [ this._path ];
	}


	void _render(Renderer renderer)
	{
		renderer._renderGraphics(this);
	}


	void lineStyle([ num width = 0.0, Colour color = const Colour(0, 0, 0), double alpha = 1.0 ])
	{
		if (this._path.points.length == 0) this._data.removeLast();

		this._lineWidth = width;
		this._lineColor	= color;
		this._lineAlpha	= alpha;
		this._path		= new _Path(_Path.POLY, width, color, alpha, this._fillAlpha, this._fillColor, this._filling, []);

		this._data.add(this._path);
	}


	void moveTo(num x, num y)
	{
		if (this._path.points.length == 0) this._data.removeLast();

		this._path = new _Path(
			_Path.POLY, this._lineWidth, this._lineColor, this._lineAlpha,
			this._fillAlpha, this._fillColor, this._filling, [ x, y ]
		);

		this._data.add(this._path);
	}


	void lineTo(num x, num y)
	{
		this._path.points.addAll([x, y]);
		this._dirtyGraphics = true;
	}


	void beginFill([ Colour color = const Colour(0, 0, 0), double alpha = 1.0 ])
	{
		this._filling	= true;
		this._fillColor	= color;
		this._fillAlpha = alpha;
	}


	void endFill()
	{
		this._filling = false;
	}


	void drawRect(num x, num y, num width, num height)
	{
		if (this._path.points.length == 0) this._data.removeLast();

		this._path = new _Path(
			_Path.RECTANGLE, this._lineWidth, this._lineColor, this._lineAlpha,
			this._fillAlpha, this._fillColor, this._filling, [ x, y, width, height ]
		);

		this._data.add(this._path);
		this._dirtyGraphics = true;
	}


	void drawCircle(num x, num y, num radius)
	{
		if (this._path.points.length == 0) this._data.removeLast();

		this._path = new _Path(
			_Path.CIRCLE, this._lineWidth, this._lineColor, this._lineAlpha,
			this._fillAlpha, this._fillColor, this._filling, [ x, y, radius ]
		);

		this._data.add(this._path);
		this._dirtyGraphics = true;
	}


	void drawEllipse(num x, num y, num width, num height)
	{
		if (this._path.points.length == 0) this._data.removeLast();

		this._path = new _Path(
			_Path.ELLIPSE, this._lineWidth, this._lineColor, this._lineAlpha,
			this._fillAlpha, this._fillColor, this._filling, [ x, y, width, height ]
		);

		this._data.add(this._path);
		this._dirtyGraphics = true;
	}


	void clear()
	{
		this._lineWidth 	= 0.0;
		this._filling		= false;
		this._dirtyGraphics	= true;
		this._dirtyClear	= true;
		this._path			= new _Path(_Path.POLY, 0, new Colour(0, 0, 0), 1.0, 1.0, new Colour(0, 0, 0), false, []);
		this._data			= [ this._path ];
	}
}


class _Path
{
	static const POLY		= 0;
	static const RECTANGLE	= 1;
	static const CIRCLE		= 2;
	static const ELLIPSE	= 3;

	int type;
	num lineWidth;
	double lineAlpha;
	Colour lineColor;
	double fillAlpha;
	Colour fillColor;
	bool filling;
	List<num> points = [];

	_Path(this.type, this.lineWidth, this.lineColor, this.lineAlpha, this.fillAlpha, this.fillColor, this.filling, this.points);
}

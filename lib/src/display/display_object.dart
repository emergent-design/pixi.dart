part of pixi;


class DisplayObject extends PixiListEntry
{
	static int _visibleCount = 0;

	// Switch to getters/setters that dirty the object
	// so that updateTransform can use that flag to avoid
	// recalculating everything each time.
	Point position	= new Point(0, 0);
	Point pivot		= new Point(0, 0);
	Point scale 	= new Point(1.0, 1.0);

	double rotation			= 0.0;
	double _rotation		= 0.0;
	double alpha			= 1.0;
	double _cacheAlpha		= 0.0;	// Used by WebGLBatch
	int _vcount				= -1;

	bool visible			= true;
	bool buttonMode			= false;
	bool _dirty				= true;
	bool _renderable		= false;
	bool get renderable => this._renderable;

	WebGLRenderGroup __group = null;
	// hitArea				= null;


	DisplayObjectContainer _parent = null;
	DisplayObjectContainer get parent => this._parent;

	Stage _stage = null;
	Stage get stage => this._stage;

	double _worldAlpha = 1.0;
	double get worldAlpha => this._worldAlpha;

	Mat3 _worldTransform = new Mat3();
	Mat3 get worldTransform => this._worldTransform;

	Mat3 _localTransform = new Mat3();
	Mat3 get localTransform => this._localTransform;

	Colour _colour	= new Colour(0, 0, 0);
	double _sinr	= 0.0;
	double _cosr	= 1.0;

	bool _filter		= false;
	bool _interactive	= false;
	bool _dynamic		= true;

	bool get interactive => this._interactive;

	void set interactive(bool i)
	{
		this._interactive = i;
		if (this.stage != null) this.stage._dirty = true;
	}


	void updateTransform()
	{
		// TODO OPTIMIZE THIS!! with dirty
		if (this.rotation != this._rotation)
		{
			this._rotation	= this.rotation;
			this._sinr		= sin(this.rotation);
			this._cosr		= cos(this.rotation);
		}

		var local 	= this._localTransform;
		var parent	= this.parent.worldTransform;
		var world	= this._worldTransform;

		local[0] =  this._cosr * this.scale.x;
		local[1] = -this._sinr * this.scale.y;
		local[3] =  this._sinr * this.scale.x;
		local[4] =  this._cosr * this.scale.y;

		var px = this.pivot.x;
		var py = this.pivot.y;

		var a00 = local[0], a01 = local[1], a02 = this.position.x - local[0] * px - py * local[1],
			a10 = local[3], a11 = local[4], a12 = this.position.y - local[4] * py - px * local[3],
			b00 = parent[0], b01 = parent[1], b02 = parent[2],
			b10 = parent[3], b11 = parent[4], b12 = parent[5];

		local[2] = a02;
		local[5] = a12;
		world[0] = b00 * a00 + b01 * a10;
		world[1] = b00 * a01 + b01 * a11;
		world[2] = b00 * a02 + b01 * a12 + b02;
		world[3] = b10 * a00 + b11 * a10;
		world[4] = b10 * a01 + b11 * a11;
		world[5] = b10 * a02 + b11 * a12 + b12;

		this._worldAlpha	= this.alpha * this.parent.worldAlpha;
		this._vcount		= _visibleCount;
	}


	void _setStage(Stage stage)
	{
		this._stage = stage;
	}

//	var _mask = null;
//	var get mask => this._mask;
//	void set mask(var m)
//	{
//		this._mask = value;
//
//		if (value)	this.addFilter(value);
//		else		this.removeFilter();
//	}

//	void addFilter(var mask)
//	{
//	}
//
//	void removeFilter()
//	{
//	}


}

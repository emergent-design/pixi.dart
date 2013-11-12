part of pixi;


abstract class DisplayObject
{
	bool _dirty				= true;
	Point _position			= new Point(0, 0);
	Point _pivot			= new Point(0, 0);
	Point _scale 			= new Point(1.0, 1.0);
	double _rotation		= 0.0;
	double _alpha			= 1.0;
	double _worldAlpha 		= 1.0;
	Mat3 _worldTransform	= new Mat3();
	bool visible			= true;
	bool buttonMode			= false;

	Point get position		=> this._position;
	Point get pivot			=> this._pivot;
	Point get scale			=> this._scale;
	double get rotation 	=> this._rotation;
	double get alpha		=> this._alpha;
	double get worldAlpha	=> this._worldAlpha;
	Mat3 get worldTransform	=> this._worldTransform;

	void set position(Point p)
	{
		this._position	= p;
		this._dirty		= true;
	}

	void set pivot(Point p)
	{
		this._pivot	= p;
		this._dirty	= true;
	}

	void set scale(Point s)
	{
		this._scale	= s;
		this._dirty	= true;
	}

	void set rotation(double r)
	{
		this._rotation	= r;
		this._dirty		= true;
	}

	void set alpha(double a)
	{
		this._alpha	= a;
		this._dirty	= true;
	}


	bool _filter		= false;
	bool _interactive	= false;
	bool _dynamic		= true;
	//bool get interactive => this._interactive;

	/*void set interactive(bool i)
	{
		this._interactive = i;
		//if (this.stage != null) this.stage._dirty = true;
	}*/


	void _updateTransform(DisplayObject parent)
	{
		if (this._dirty)
		{
			double sinr	= sin(this._rotation);
			double cosr	= cos(this._rotation);
			var root	= parent._worldTransform;
			var world	= this._worldTransform;
			double lxa	=  cosr * this._scale.x;	//
			double lya	= -sinr * this._scale.y;	// Local transform
			double lxb	=  sinr * this._scale.x;	//
			double lyb	=  cosr * this._scale.y;	//
			var px		= this._pivot.x;
			var py		= this._pivot.y;

			var a00 = lxa, a01 = lya, a02 = this._position.x - lxa * px - py * lya,
				a10 = lxb, a11 = lyb, a12 = this._position.y - lyb * py - px * lxb,
				b00 = root[0],	b01 = root[1],	b02 = root[2],
				b10 = root[3],	b11 = root[4],	b12 = root[5];

			world[0] = b00 * a00 + b01 * a10;
			world[1] = b00 * a01 + b01 * a11;
			world[2] = b00 * a02 + b01 * a12 + b02;
			world[3] = b10 * a00 + b11 * a10;
			world[4] = b10 * a01 + b11 * a11;
			world[5] = b10 * a02 + b11 * a12 + b12;

			this._worldAlpha	= this._alpha * parent.worldAlpha;
			this._dirty			= false;
		}
	}


	// Default is no-op for a non-renderable object, should be
	// overridden by derived display objects that are renderable.
	void _render(Renderer renderer) {}



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

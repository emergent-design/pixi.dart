part of pixi;


class Stage extends DisplayObjectContainer
{
	Mat3 _worldTransform	= new Mat3();
	bool _dirty				= true;

	Colour backgroundColor;
	bool interactive;


	Stage([this.backgroundColor = const Colour(255, 255, 255), this.interactive = false])
	{
		this._stage = this;
		//this._list.add(this);
	}


	void updateTransform()
	{
		this._worldAlpha	= 1.0;
		this._vcount		= DisplayObject._visibleCount;

		for (var c in this._children) c.updateTransform();

		if (this._dirty)
		{
			this._dirty = false;
			//this.interactionManager.dirty = true;
		}

		//if (this.interactive) this.interactionManager.update();
	}
}

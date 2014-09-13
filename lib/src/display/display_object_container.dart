part of pixi;


class DisplayObjectContainer extends DisplayObject
{
	List<DisplayObject> _children = []; //toObservable([]);
	List<DisplayObject> get children => this._children;


	/*DisplayObjectContainer()
	{
		(this._children as ObservableList).changes.listen((e) => this._invalidate());
	}*/


	void _render(Renderer renderer)
	{
		for (var c in this._children)
		{
			if (c.visible)
			{
				c._updateTransform(this);
				c._render(renderer);
			}
		}
	}


	void _invalidate()
	{
		super._invalidate();

		for (var c in this._children) c._invalidate();
	}
}

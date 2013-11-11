part of pixi;


class DisplayObjectContainer extends DisplayObject
{
	List<DisplayObject> _children = [];
	List<DisplayObject> get children => this._children;


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
}

part of pixi;


class _InteractionManager
{
	Renderer owner;
	Element element;
	Stage stage;


	_InteractionManager(this.owner, this.element)
	{
		document.body.onMouseUp.listen(this.onMouseUp);
		this.element.onMouseMove.listen(this.onMouseMove);
		this.element.onMouseDown.listen(this.onMouseDown);
		this.element.onMouseOut.listen(this.onMouseOut);
		this.element.onTouchStart.listen(this.onTouchStart);
		this.element.onTouchEnd.listen(this.onTouchEnd);
		this.element.onTouchMove.listen(this.onTouchMove);
	}


	void onMouseUp(MouseEvent e)
	{

	}


	void onMouseMove(MouseEvent e)
	{
		var rect	= this.element.getBoundingClientRect();
		double x	= (e.client.x - rect.left) * (this.owner._width / rect.width);
		double y	= (e.client.y - rect.top) * (this.owner._height / rect.height);

		this.propagateMove(this.stage, x, y);
	}


	void propagateMove(DisplayObject object, double x, double y)
	{
		if (object.interactive)
		{
			if (object._controller.listening("mouseOver") || object._controller.listening("mouseOut"))
			{
				if (object._hit(x, y))
				{
					if (!object._over)
					{
						object._over = true;
						object._controller["mouseOver"].add(new InteractionEvent(x, y));
					}
				}
				else if (object._over)
				{
					object._over = false;
					object._controller["mouseOut"].add(new InteractionEvent(x, y));
				}
			}
		}

		if (object is DisplayObjectContainer)
		{
			for (var c in object.children) this.propagateMove(c, x, y);
		}
	}

	/*PIXI.InteractionManager.prototype.onMouseMove = function(event)
{
    this.mouse.originalEvent = event || window.event; //IE uses window.event
    // TODO optimize by not check EVERY TIME! maybe half as often? //
    var rect = this.interactionDOMElement.getBoundingClientRect();

    this.mouse.global.x = (event.clientX - rect.left) * (this.target.width / rect.width);
    this.mouse.global.y = (event.clientY - rect.top) * ( this.target.height / rect.height);

    var length = this.interactiveItems.length;

    for (var i = 0; i < length; i++)
    {
        var item = this.interactiveItems[i];

        if(item.mousemove)
        {
            //call the function!
            item.mousemove(this.mouse);
        }
    }
};*/


	void onMouseDown(MouseEvent e)
	{

	}


	void onMouseOut(MouseEvent e)
	{

	}

	void onTouchStart(TouchEvent e)
	{
	}


	void onTouchEnd(TouchEvent e)
	{
	}


	void onTouchMove(TouchEvent e)
	{
	}
}

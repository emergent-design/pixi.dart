part of pixi;


class _InteractionManager
{
	Renderer owner;
	Element element;
	Stage stage;


	_InteractionManager(this.owner, this.element)
	{
		document.onMouseUp.listen(this.onMouseInteraction);
		this.element.onMouseDown.listen(this.onMouseInteraction);
		this.element.onMouseMove.listen(this.onMouseInteraction);
		this.element.onTouchStart.listen(this.onTouchInteraction);
		this.element.onTouchEnd.listen(this.onTouchInteraction);
		this.element.onTouchMove.listen(this.onTouchInteraction);
	}


	void onMouseInteraction(MouseEvent e)
	{
		if (this.stage == null) return;

		var rect	= this.element.getBoundingClientRect();
       	double x	= (e.client.x - rect.left) * (this.owner._width / rect.width);
        double y	= (e.client.y - rect.top) * (this.owner._height / rect.height);

    	switch (e.type)
    	{
    		case "mousemove":	this.propagateMove(this.stage, x, y);	break;
    		case "mousedown":	this.propagateDown(this.stage, x, y);	break;
    		case "mouseup":		this.propagateUp(this.stage, x, y);		break;
    	}
	}


	void onTouchInteraction(TouchEvent e)
	{
		if (this.stage == null) return;

		for (var t in e.changedTouches)
		{
			var rect	= this.element.getBoundingClientRect();
            double x	= (t.client.x - rect.left) * (this.owner._width / rect.width);
            double y	= (t.client.y - rect.top) * (this.owner._height / rect.height);

			switch (e.type)
			{
				case "touchstart":	this.propagateStart(this.stage, t.identifier, x, y);	break;
				case "touchend":	this.propagateEnd(this.stage, t.identifier, x, y);		break;
				case "touchmove":	this.propagateTouch(this.stage, t.identifier, x, y);	break;
			}

		}

		if (e.type == "touchmove") e.preventDefault();
	}


	void propagateDown(DisplayObject object, double x, double y)
	{
		if (object.interactive)
		{
			if (object._hit(x, y))
			{
				if (object._controller.listening("mouseDown")) object._controller["mouseDown"].add(new InteractionEvent(0, x, y));
				object._down = true;
			}
		}

		if (object is DisplayObjectContainer)
		{
			for (var c in object.children) this.propagateDown(c, x, y);
		}
	}


	void propagateUp(DisplayObject object, double x, double y)
	{
		if (object.interactive)
		{
			// The stage gets the mouse up event regardless of the hit test
			// so that we can catch mouseup when the mouse has moved outside
			// of the canvas.
			if (object == this.stage && object._controller.listening("mouseUp"))
			{
				object._controller["mouseUp"].add(new InteractionEvent(0, x, y));
			}
			else if (object._hit(x, y))
			{
				if (object._controller.listening("mouseUp"))
				{
					object._controller["mouseUp"].add(new InteractionEvent(0, x, y));
				}

				if (object._down && object._controller.listening("click"))
				{
					object._controller["click"].add(new InteractionEvent(0, x, y));
				}
			}

			object._down = false;
		}

		if (object is DisplayObjectContainer)
		{
			for (var c in object.children) this.propagateUp(c, x, y);
    	}
	}


	void propagateStart(DisplayObject object, int id, double x, double y)
	{
		if (object.interactive)
		{
			if (object._hit(x, y))
			{
				if (object._controller.listening("touchStart"))
				{
					object._controller["touchStart"].add(new InteractionEvent(id, x, y));
				}

				object._over	= true;
				object._down	= true;
				object._touches.add(id);
			}
		}

		if (object is DisplayObjectContainer)
		{
			for (var c in object.children) this.propagateStart(c, id, x, y);
		}
	}


	void propagateEnd(DisplayObject object, int id, double x, double y)
	{
		if (object.interactive && object._touches.contains(id))
		{
			if (object == this.stage || object._hit(x, y))
			{
				if (object._controller.listening("touchEnd"))
				{
					object._controller["touchEnd"].add(new InteractionEvent(id, x, y));
				}

				if (object._over && object._controller.listening("tap"))
				{
					object._controller["tap"].add(new InteractionEvent(id, x, y));
				}

				object._over = false;
			}

			object._down = false;
			object._touches.remove(id);
		}


		if (object is DisplayObjectContainer)
		{
			for (var c in object.children) this.propagateEnd(c, id, x, y);
		}
	}


	void propagateTouch(DisplayObject object, int id, double x, double y)
	{
		if (object.interactive && object._controller.listening("touchMove") && object._touches.contains(id))
		{
			object._controller["touchMove"].add(new InteractionEvent(id, x, y));
		}

		if (object is DisplayObjectContainer)
		{
			for (var c in object.children) this.propagateTouch(c, id, x, y);
		}
	}


	void propagateMove(DisplayObject object, double x, double y)
	{
		if (object.interactive)
		{
			if (object._hit(x, y))
			{
				if (!object._over)
				{
					object._over = true;

					if (object._controller.listening("mouseOver"))
					{
						object._controller["mouseOver"].add(new InteractionEvent(0, x, y));
					}
				}
			}
			else if (object._over)
			{
				object._over = false;

				if (object._controller.listening("mouseOut"))
				{
					object._controller["mouseOut"].add(new InteractionEvent(0, x, y));
				}
			}

			if (object._controller.listening("mouseMove"))
			{
				object._controller["mouseMove"].add(new InteractionEvent(0, x, y));
			}
		}

		if (object is DisplayObjectContainer)
		{
			for (var c in object.children) this.propagateMove(c, x, y);
		}
	}
}

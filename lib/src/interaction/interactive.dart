part of pixi;


class InteractionEvent
{
	final num x;
	final num y;
	final int id;

	InteractionEvent(this.id, this.x, this.y);
}


class _InteractiveController
{
	Map<String, StreamController<InteractionEvent>> controllers = {};

	StreamController<InteractionEvent> operator [] (String type)
	{
		return this.controllers.putIfAbsent(type, () => new StreamController<InteractionEvent>.broadcast());
	}

	void clear()
	{
		for (var c in this.controllers.values) c.close();
		this.controllers.clear();
	}

	bool has(String type)		=> this.controllers.containsKey(type);
	bool listening(String type)	=> this.controllers.containsKey(type) && this.controllers[type].hasListener;
	bool get enabled			=> this.controllers.isNotEmpty;
}


// A DisplayObject will become interactive automatically if you access
// any of the event streams.
abstract class _Interactive
{
	_InteractiveController _controller			= new _InteractiveController();
	Stream<InteractionEvent> get onClick		=> this._controller["click"].stream;
	Stream<InteractionEvent> get onMouseDown	=> this._controller["mouseDown"].stream;
	Stream<InteractionEvent> get onMouseUp		=> this._controller["mouseUp"].stream;
	Stream<InteractionEvent> get onMouseOver	=> this._controller["mouseOver"].stream;
	Stream<InteractionEvent> get onMouseOut		=> this._controller["mouseOut"].stream;
	Stream<InteractionEvent> get onMouseMove	=> this._controller["mouseMove"].stream;
	Stream<InteractionEvent> get onTap			=> this._controller["tap"].stream;
	Stream<InteractionEvent> get onTouchStart	=> this._controller["touchStart"].stream;
	Stream<InteractionEvent> get onTouchEnd		=> this._controller["touchEnd"].stream;
	Stream<InteractionEvent> get onTouchMove	=> this._controller["touchMove"].stream;
	void clearEvents() 							=> this._controller.clear();
	bool get interactive						=> this._controller.enabled;
	bool get isDown								=> _down;
	bool get isOver								=> _over;

	bool _over 			= false;
	bool _down 			= false;
	Set<int> _touches	= new Set<int>();
	HitArea hitArea		= null;

	Point _transform(double x, double y);
	bool _hit(double x, double y);
}

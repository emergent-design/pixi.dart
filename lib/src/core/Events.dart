part of pixi.core;


// @JS()
// class EventEmitter
// {
// }
// ???


@JS()
class InteractionData
{
	external InteractionData();

	external Point get global;
	external DisplayObject get target;
	external Event get originalEvent;

	external Point getLocalPosition(DisplayObject displayObject, [ Point point,  Point globalPos ]);
}


@JS()
@anonymous
class PixiEvent
{
	external bool get stopped;
	external String get type;
	external DisplayObject get target;
	external InteractionData get data;

	external void stopPropagation();
}

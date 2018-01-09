part of pixi.core;


@JS()
class DisplayObject
{
	external DisplayObject();

	// Properties
	external num get alpha;
	external set alpha(num value);

	external bool get cacheAsBitmap;
	external set cacheAsBitmap(bool value);

	external Rectangle get filterArea;
	external set filterArea(Rectangle value);

	external List<Filter> get filters;
	external set filters(List<Filter> value);

	external Matrix get localTransform;

	// Only supports Graphics and Sprites
	external DisplayObject get mask;
	external set mask(DisplayObject value);

	external Container get parent;

	external Point get pivot;
	external set pivot(Point point);

	external Point get position;
	external set position(Point point);

	external bool get renderable;
	external set renderable(bool value);

	external num get rotation;
	external set rotation(num value);

	external Point get scale;
	external set scale(Point point);

	external Point get skew;
	external set skew(Point point);

	external bool get visible;
	external set visible(bool value);

	external num get worldAlpha;
	external Matrix get worldTransform;
	external bool get worldVisible;

	external num get x;
	external set x(num value);
	external num get y;
	external set y(num value);

	// Methods
	external void destroy();
	external Rectangle getBounds(bool skipUpdate, [ Rectangle rect ]);
	external Rectangle getLocalBounds([ Rectangle rect ]);
	external Container setParent(Container container);
	external Point toGlobal(Point position);
	external Point toLocal(Point position, DisplayObject from);

	// EventEmitter API
	external DisplayObject on(String eventName, void listener(PixiEvent event));
	external DisplayObject once(String eventName, void listener(PixiEvent event));
	external DisplayObject removeListener(String eventName, void listener(PixiEvent event));

	// Interactive target
	external bool get interactive;
	external set interactive(bool value);

	external bool get buttonMode;
	external set buttonMode(bool value);

	external Shape get hitArea;
	external set hitArea(Shape value);

	external String get cursor;
	external set cursor(String value);

	// These don't actually exist in the JS library but utilise the dynamic nature
	// of JS interop to provide the ability to add arbitrary data to an object.
	external dynamic get userdata;
	external set userdata(dynamic value);
}


@JS() @anonymous
class DestroyOptions
{
	external factory DestroyOptions({
		bool children,
		bool texture,
		bool baseTexture
	});
}


@JS()
class Container extends DisplayObject
{
	external List<DisplayObject> get children;

	external num get height;
	external set height(num value);

	external num get width;
	external set width(num value);

	external bool get interactiveChildren;
	external set interactiveChildren(bool value);


	external Container();

	// external DisplayObject addChild(DisplayObject child);
	// Declared as function so that it can take an arbitrary number of arguments
	external Function get addChild;
	external DisplayObject addChildAt(DisplayObject child, num index);

	external void destroy([ DestroyOptions options ]);

	external DisplayObject getChildAt(num index);
	external num getChildIndex(DisplayObject child);

	external DisplayObject removeChild(DisplayObject child);
	external DisplayObject removeChildAt(num index);
	external void removeChildren([num beginIndex, num endIndex]);

	external void setChildIndex(DisplayObject child, num index);
	external void swapChildren(DisplayObject child, DisplayObject child2);
}


@JS()
class TransformBase
{
	external Matrix get worldTransform;
	external set worldTransform(Matrix matrix);

	external Matrix get localTransform;
	external set localTransform(Matrix matrix);

	external void updateLocalTransform();
	external void updateTransform(TransformBase parentTransform);
	external void updateWorldTransform(TransformBase parentTransform);
}


@JS()
class Transform extends TransformBase
{
	external Point get pivot;
	external set pivot(Point value);

	external Point get position;
	external set position(Point value);

	external num get rotation;
	external set rotation(num value);

	external Point get scale;
	external set scale(Point value);

	external Point get skew;
	external set skew(Point value);

	external void setFromMatrix(Matrix matrix);
}


@JS()
class TransformStatic extends Transform {}

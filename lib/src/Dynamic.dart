@JS()
library pixi.dynamic;

import 'package:js/js.dart';


@JS()
@anonymous
class DynamicSource {}


@JS()
@anonymous
class DynamicDescription
{
	external get value;

	external factory DynamicDescription({bool configurable, bool enumerable, bool writable, value });
}


// Interop to ES5+ functions that will allow us to get/set arbitrary properties on
// anonymous javascript objects.
@JS('Object.defineProperty')
external void defineProperty(object, String property, DynamicDescription description);

@JS('Object.getOwnPropertyDescriptor')
external DynamicDescription getOwnPropertyDescriptor(object, String property);


// A helper class for dealing with proxying anonymous JS objects that are to be
// used as maps and therefore do not have a fixed structure that can be defined
// ahead of time.
class Dynamic<T>
{
	DynamicSource source;


	Dynamic(this.source);


	T operator [](String key)
	{
		return getOwnPropertyDescriptor(this.source, key)?.value;
	}


	operator []=(String key, T value)
	{
		defineProperty(this.source, key, new DynamicDescription(
			value: value, writable: true, enumerable: true, configurable: true
		));

		return value;
	}
}

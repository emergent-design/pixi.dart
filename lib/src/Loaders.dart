@JS('PIXI.loaders')
library pixi.loaders;

import 'package:js/js.dart';
import 'Dynamic.dart';


@JS()
class Resource
{
	external String get name;
	external String get url;
	external bool get isDataUrl;
	external dynamic get data;
	external dynamic get texture;
}


@JS()
class Loader
{
	external DynamicSource get resources;


	external Loader();

	external Loader add(String name, [ String url, LoaderOptions options, void callback(Loader loader, DynamicSource resources) ]);
	external Loader once(String name, void callback(Loader loader, DynamicSource resources));
	external Loader load([ void callback(Loader loader, DynamicSource resources) ]);

	external void reset();
}


@JS()
@anonymous
class LoaderOptions
{
	external factory LoaderOptions({ bool crossOrigin, int loadType, String xhrType });
}

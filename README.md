pixi.dart
=========

A [Dart](https://www.dartlang.org/) wrapper for [PixiJS](https://github.com/pixijs/pixi.js).

The version number of this package mirrors that of the PixiJS library it wraps. An official build
of minified pixijs is provided as part of the package. You must link to this in your root HTML file
(e.g. index.html) before referencing your Dart application:

```html
	<script src="packages/pixi/js/pixi.min.js"></script>
	<script defer src="index.dart.js"></script>
```

The [PixiJS documentation](http://pixijs.download/release/docs/index.html) can be used
as reference with a few exceptions such as the loading of shaders (see the custom-filter
example).

Remember to wrap all callback functions that are passed to JS with ```allowInterop()```.


Usage
-----

```dart
import 'dart:html' hide Point;
import 'package:pixi/pixi.dart';
import 'package:js/js.dart';

class BunnyExample
{
	Application app	= Application();
	Sprite bunny	= Sprite.fromImage('bunny.png');

	BunnyExample()
	{
		document.body.append(app.view);

		this.bunny
			..anchor 	= Point(0.5, 0.5)
			..position	= Point(200, 150);

		app.stage.addChild(this.bunny);
		app.ticker.add(allowInterop(
			(_) => this.bunny.rotation += 0.1
		));
	}
}

void main()
{
	new BunnyExample();
}
```

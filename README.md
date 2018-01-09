pixi.dart
=========

A [Dart](https://www.dartlang.org/) wrapper for [PixiJS](https://github.com/pixijs/pixi.js).

The version number of this package mirrors that of the PixiJS library it wraps. An official build
of minified pixijs is provided as part of the package.

[The PixiJS documentation](http://pixijs.download/release/docs/index.html) can be used
as reference with a few exceptions such as the loading of shaders (see the custom-filter
example).

Remember to wrap all callback functions that are passed to JS with ```allowInterop()```.


Usage
-----

```dart
import 'dart:html';
import 'package:pixi/pixi.dart';

class BunnyExample
{
	var app		= new Application();
	var bunny	= new Sprite.fromImage('bunny.png');

	BunnyExample()
	{
		document.body.append(app.view);

		this.bunny
			..anchor 	= new Point(0.5, 0.5);
			..position	= new Point(200, 150);

		app.stage.children.add(this.bunny);
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

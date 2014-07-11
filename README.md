pixi.dart
=========

A [Dart](https://www.dartlang.org/) port of [pixi.js](https://github.com/GoodBoyDigital/pixi.js/).


Work in Progress
----------------

Implemented so far:

* Canvas renderer
* WebGL renderer (with automatic batching)
* Full scene graph
* Asset loader / sprite sheet loader
* Text
* BitmapFont text
* Multiline text
* Primitive drawing
* Interaction (mouse and touch events)


Usage
-----

```dart
import 'dart:html';
import 'package:pixi/pixi.dart';


class BunnyExample
{
	var renderer	= new CanvasRenderer(400, 300);
	var stage		= new Stage(new Colour.fromHtml('#6f9'));
	var bunny		= new Sprite.fromImage("bunny.png");


	BunnyExample()
	{
		document.body.append(this.renderer.view);

		this.bunny.anchor 	= new Point(0.5, 0.5);
		this.bunny.position	= new Point(200, 150);

		this.stage.children.add(this.bunny);

		window.requestAnimationFrame(this._animate);
	}


	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);

		this.bunny.rotation += 0.1;

		this.renderer.render(this.stage);
	}
}


void main()
{
	new BunnyExample();
}
```

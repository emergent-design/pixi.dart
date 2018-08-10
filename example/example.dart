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

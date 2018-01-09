part of pixi.examples;


class FilterDemo extends Example
{
	Application app;
	double count = 0.0;

	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(view: canvas))
			..stage.interactive = true;

		// var bg = Sprite.fromImage('assets/demos/BGrotate.jpg')
		// 	..anchor.set(0.5)
		// 	..x = app.screen.width / 2
		// 	..y = app.screen.height / 2;

		// app.stage.addChild(bg);

		var filter = new ColorMatrixFilter();
		var container = new Container()
			..x = app.screen.width / 2
			..y = app.screen.height / 2;

		var bgFront = Sprite.fromImage('assets/demos/SceneRotate.jpg')
			..anchor.set(0.5);

		container.addChild(bgFront);

		var lights = [
			Sprite.fromImage('assets/demos/LightRotate1.png')..anchor.set(0.5),
			Sprite.fromImage('assets/demos/LightRotate2.png')..anchor.set(0.5)
		];

		container.addChild(lights[1], lights[0]);

		var panda = Sprite.fromImage('assets/demos/panda.png')
			..anchor.set(0.5);

		container.addChild(panda);

		app.stage.addChild(container);
		app.stage.filters = [ filter ];

		app.stage.on('pointertap', allowInterop((e) {
			app.stage.filters = app.stage.filters.isEmpty ? [ filter ] : [];
		}));

		app.stage.addChild(new Text('Click or tap to turn filters on / off.', new TextStyle(
			fontFamily: 'Arial',
			fontSize: 12,
			fontWeight: 'bold',
			fill: 'white'
		)));

		app.ticker.add(allowInterop((_) {
			bgFront.rotation	-= 0.01;
			lights[1].rotation	+= 0.02;
			lights[0].rotation	+= 0.01;

			panda.scale.set(
				1 + sin(count) * 0.04,
				1 + cos(count) * 0.04
			);

			count += 0.1;

			var matrix	= filter.matrix;
			matrix[1]	= sin(count) * 3;
			matrix[2]	= cos(count);
			matrix[3]	= cos(count) * 1.5;
			matrix[4]	= sin(count / 3) * 2;
			matrix[5]	= sin(count / 2);
			matrix[6]	= sin(count / 4);
		}));
	}
}
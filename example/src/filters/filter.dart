part of pixi.examples;


class FilterDemo extends Example
{
	Application app;
	double c = 0.0;

	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(view: canvas))
			..stage.interactive = true;

		// var bg = Sprite.fromImage('assets/demos/BGrotate.jpg')
		// 	..anchor.set(0.5)
		// 	..x = app.screen.width / 2
		// 	..y = app.screen.height / 2;

		// app.stage.addChild(bg);

		var filter		= new ColorMatrixFilter();
		var container	= new Container()
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
				1 + sin(c) * 0.04,
				1 + cos(c) * 0.04
			);

			c += 0.1;

			filter.matrix = [
				1, sin(c) * 3, cos(c), cos(c) * 1.5,  sin(c / 3) * 2,
				sin(c / 2), sin(c / 4), 0, 0, 0,
				0, 0, 1, 0, 0,
				0, 0, 0, 1, 0
			];
		}));
	}
}

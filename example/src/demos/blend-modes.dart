part of pixi.examples;



class BlendModesDemo extends Example
{
	Application app;
	List<Sprite> dudes;
	Rectangle dudeBounds;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(view: canvas));

		var background = Sprite.fromImage('assets/demos/BGrotate.jpg')
			..width = app.screen.width
			..height = app.screen.height;


		this.dudes = new List.generate(20, (i) =>
			Sprite.fromImage('assets/demos/flowerTop.png')
				..anchor.set(0.5)
				..scale.set(0.8 + random.nextDouble() * 0.3)
				..x = (random.nextDouble() * app.screen.width).floor()
				..y = (random.nextDouble() * app.screen.height).floor()
				..blendMode = BLEND_MODES.ADD
				..userdata = new Dude(
					direction: random.nextDouble() * pi * 2,
					turningSpeed: random.nextDouble() - 0.8,
					speed: 2 + random.nextDouble() * 2
				)
		);

		this.dudeBounds = new Rectangle(
			-100, -100,
			app.screen.width + 100 * 2,
			app.screen.height + 100 * 2
		);

		app.stage.addChild(background);
		this.dudes.forEach((d) => app.stage.addChild(d));
		app.ticker.add(allowInterop(animate));
	}

	void animate(num d)
	{
		for (var dude in this.dudes)
		{
			Dude.move(dude, this.dudeBounds);
		}
	}
}
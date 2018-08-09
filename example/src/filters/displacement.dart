part of pixi.examples;


class DisplacementFilterDemo extends Example
{
	Application app;
	List<Sprite> maggots;
	Sprite displacementSprite;
	Sprite ring;
	Rectangle bounds;
	double count = 0.0;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(view: canvas))
			..stage.interactive = true;

		this.bounds = new Rectangle(
			-100, -100,
			app.screen.width + 100 * 2,
			app.screen.height + 100 * 2
		);

		this.displacementSprite = Sprite.fromImage('assets/filters/displace.png')
			..anchor.set(0.5);

		var displacementFilter = new DisplacementFilter(displacementSprite)
			..scale.set(110);

		var container = new Container()
			..filters = [ displacementFilter ];

		this.ring = Sprite.fromImage('assets/filters/ring.png')
			..anchor.set(0.5)
			..visible = false;

		this.maggots = new List.generate(20, (i) =>
			Sprite.fromImage('assets/filters/maggot.png')
				..anchor.set(0.5)
				..scale.set(1 + random.nextDouble() * 0.3)
				..x = random.nextDouble() * bounds.width
				..y = random.nextDouble() * bounds.height
				..userdata = new Dude(
					direction: random.nextDouble() * pi * 2,
					speed: 1.0,
					turningSpeed: random.nextDouble() - 0.8
				)
		);

		this.maggots.forEach((m) {
			m.userdata.offset = m.scale.x;	// Store the starting scale in offset
			container.addChild(m);
		});

		var bg = Sprite.fromImage('assets/basics/bkg-grass.jpg')
			..width = app.screen.width
			..height = app.screen.height
			..alpha = 0.4;

		container.addChild(bg);
		app.stage.addChild(container, displacementSprite, ring);
		app.stage.on('pointermove', allowInterop(onPointerMove));
		app.ticker.add(allowInterop(animate));
	}

	void onPointerMove(PixiEvent event)
	{
		this.ring.visible = true;
		this.displacementSprite.position.set(
			event.data.global.x - 25,
			event.data.global.y
		);
		this.ring.position.copy(this.displacementSprite.position);
	}

	void animate(num d)
	{
		count += 0.05;

		for (var dude in this.maggots)
		{
			Dude.move(dude, this.bounds, scale: (offset) {
				dude.scale.x = offset + sin(count) * 0.2;
				return 1.0;
			});
		}
	}
}
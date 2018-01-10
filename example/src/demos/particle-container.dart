part of pixi.examples;


class ParticleContainerDemo extends Example
{
	Application app;
	List<Sprite> maggots;
	Rectangle dudeBounds;
	double tick = 0.0;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(view: canvas));

		var sprites = new ParticleContainer(10000, new ParticleProperties(
			scale: true,
			position: true,
			rotation: true,
			uvs: true,
			alpha: true
		));

		var totalSprites = app.renderer.type == RENDERER_TYPE.WEBGL ? 10000 : 100;

		this.maggots = new List.generate(totalSprites, (i) =>
			Sprite.fromImage('assets/demos/tinyMaggot.png')
				..anchor.set(0.5)
				..scale.set(0.8 + random.nextDouble() * 0.3)
				..x = random.nextDouble() * app.screen.width
				..y = random.nextDouble() * app.screen.height
				..tint = random.nextDouble() * 0x808080
				..userdata = new Dude(
					direction: random.nextDouble() * PI * 2,
					turningSpeed: random.nextDouble() - 0.8,
					speed: (2 + random.nextDouble() * 2) * 0.2,
					offset: random.nextDouble() * 100
				)
		);

		this.maggots.forEach((d) => sprites.addChild(d));

		this.dudeBounds = new Rectangle(
			-100, -100,
			app.screen.width + 100 * 2,
			app.screen.height + 100 * 2
		);

		app.stage.addChild(sprites);
		app.ticker.add(allowInterop(animate));
	}

	void animate(num d)
	{
		for (var dude in this.maggots)
		{
			Dude.move(dude, this.dudeBounds,
				rotationOffset: PI,
				scale: (offset) => dude.scale.y = 0.95 + sin(tick + offset) * 0.05
			);
		}
		this.tick += 0.1;
	}
}

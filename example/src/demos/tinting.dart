part of pixi.examples;


class TintingDemo extends Example
{
	Application app;
	List<Sprite> aliens;
	Rectangle dudeBounds;

	TintingDemo();

	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(view: canvas));

		this.aliens = new List.generate(20, (i) =>
			Sprite.fromImage('assets/demos/eggHead.png')
				..anchor.set(0.5)
				..scale.set(0.8 + random.nextDouble() * 0.3)
				..x = (random.nextDouble() * app.screen.width).floor()
				..y = (random.nextDouble() * app.screen.height).floor()
				..tint = random.nextDouble() * 0xffffff
				..userdata = new Dude(
					direction: random.nextDouble() * PI * 2,
					turningSpeed: random.nextDouble() - 0.8,
					speed: 2 + random.nextDouble() * 2
				)
		);

		this.dudeBounds = new Rectangle(
			-100, -100,
			app.screen.width + 100 * 2,
			app.screen.height + 100 * 2
		);

		this.aliens.forEach((d) => app.stage.addChild(d));
		app.ticker.add(allowInterop(animate));
	}


	void animate(num d)
	{
		for (var dude in this.aliens)
		{
			Dude.move(dude, this.dudeBounds);
		}
	}
}

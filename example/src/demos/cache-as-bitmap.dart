part of pixi.examples;


class CacheAsBitmapDemo extends Example
{
	Application app;
	Container alienContainer;
	List<Sprite> aliens;
	double count = 0.0;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(view: canvas))
			..stop();

		this.alienContainer = new Container()
			..x = 400
			..y = 300;

		new Loader()
			..add('spritesheet', 'assets/demos/monsters.json')
			..load(allowInterop(onAssetsLoaded));

		app.stage.interactive = true;
		app.stage.on('pointertap', allowInterop(onClick));
		app.stage.addChild(this.alienContainer);
		app.ticker.add(allowInterop(animate));
	}


	void onClick(PixiEvent)
	{
		this.alienContainer.cacheAsBitmap = !this.alienContainer.cacheAsBitmap;
	}


	void onAssetsLoaded(Loader loader, DynamicSource resources)
	{
		final List<String> alienFrames = const [
			'eggHead.png',
			'flowerTop.png',
			'helmlok.png',
			'skully.png'
		];

		this.aliens = new List.generate(100, (i) =>
			Sprite.fromFrame(alienFrames[i % 4])
				..anchor.set(0.5)
				..tint = random.nextDouble() * 0xffffff
				..x = random.nextDouble() * 800 - 400
				..y = random.nextDouble() * 600 - 300
		);

		this.aliens.forEach((a) => this.alienContainer.addChild(a));
		app.start();
	}

	void animate(num)
	{
		for (var a in this.aliens)
		{
			a.rotation += 0.1;
		}

		count += 0.01;

		this.alienContainer
			..scale.set(sin(count))
			..rotation += 0.01;
	}
}


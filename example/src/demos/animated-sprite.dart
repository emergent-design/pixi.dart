part of pixi.examples;


class AnimatedSpriteDemo extends Example
{
	Application app;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(view: canvas))
			..stop();

		new Loader()
			.add('spritesheet', 'assets/demos/mc.json')
			.load(allowInterop(onAssetsLoaded));
	}


	void onAssetsLoaded(Loader loader, DynamicSource resources)
	{
		var explosionTextures = new List.generate(27, (i) => Texture.fromFrame("Explosion_Sequence_A ${i+1}.png"));

		for (int i=0; i<50; i++)
		{
			var explosion = new AnimatedSprite(explosionTextures)
				..position.x	= random.nextDouble() * app.screen.width
				..position.y	= random.nextDouble() * app.screen.height
				..rotation		= random.nextDouble() * pi
				..scale.set(0.75 + random.nextDouble() * 0.5)
				..anchor.set(0.5)
				..gotoAndPlay(random.nextInt(27));

			app.stage.addChild(explosion);
		}

		app.start();
	}
}



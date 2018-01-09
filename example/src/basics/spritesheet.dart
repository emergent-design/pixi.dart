part of pixi.examples;


class SpriteSheetExample extends Example
{
	Application app;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(view: canvas));

		new Loader()
			.add('assets/basics/fighter.json')
			.load(allowInterop(onAssetsLoaded));
	}


	void onAssetsLoaded(Loader loader, DynamicSource resources)
	{
		var frames = new List.generate(30, (i) => Texture.fromFrame(
			"rollSequence00${i.toString().padLeft(2, '0')}.png")
		);

		var sprite = new AnimatedSprite(frames)
			..animationSpeed = 0.5
			..position.set(app.screen.width / 2, app.screen.height / 2)
			..anchor.set(0.5)
			..play();

		app.stage.addChild(sprite);
		app.ticker.add(allowInterop(
			(d) => sprite.rotation += 0.01
		));
	}
}

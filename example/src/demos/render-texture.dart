part of pixi.examples;


class RenderTextureDemo extends Example
{
	Application app;
	double count = 0.0;
	List<Sprite> items;
	List<RenderTexture> textures;
	Sprite outputSprite;
	Container stuffContainer;


	void run(CanvasElement canvas)
	{
		this.app		= new Application(new Options(view: canvas));
		this.textures	= [
			RenderTexture.create(app.screen.width, app.screen.height),
			RenderTexture.create(app.screen.width, app.screen.height)
		];

		this.outputSprite = new Sprite(this.textures[0])
			..anchor.set(0.5)
			..x = 400
			..y = 300;

		this.stuffContainer = new Container()
			..x = 400
			..y = 300;

		app.stage.addChild(outputSprite);
		app.stage.addChild(stuffContainer);

		var fruits = new List.generate(8, (i) => "assets/demos/spinObj_0${i+1}.png");
		this.items = new List.generate(20, (i) =>
			Sprite.fromImage(fruits[i % fruits.length])
				..anchor.set(0.5)
				..x = random.nextDouble() * 400 - 200
				..y = random.nextDouble() * 400 - 200
		)..forEach((i) => stuffContainer.addChild(i));

		app.ticker.add(allowInterop(animate));
	}

	void animate(num d)
	{
		for (var i in this.items)
		{
			i.rotation += 0.1;
		}

		count += 0.01;

		var temp			= this.textures[0];
		this.textures[0]	= this.textures[1];
		this.textures[1]	= temp;

		this.outputSprite.texture = this.textures[0];
		this.stuffContainer.rotation -= 0.01;
		this.outputSprite.scale.set(1 + sin(count) * 0.2);

		app.renderer.render(app.stage, this.textures[1], false);
	}
}

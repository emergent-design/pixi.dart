part of pixi.examples;


class RenderTextureExample extends Example
{
	Application app;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(
			width: 800,
			height: 600,
			backgroundColor: 0x1099bb,
			view: canvas
		));

		var container	= new Container()
			..x = 100
			..y = 60;

		for (int j=0; j<5; j++)
		{
			for (int i=0; i<5; i++)
			{
				var bunny = Sprite.fromImage('assets/basics/bunny.png')
					..x = 30 * i
					..y = 30 * j
					..rotation = random.nextDouble() * PI * 2;

				container.addChild(bunny);
			}
		}

		var brt 		= new BaseRenderTexture(300, 300, SCALE_MODES.LINEAR, 1);
		var rt			= new RenderTexture(brt);
		var sprite		= new Sprite(rt)
			..x = 450
			..y = 60;

		app.stage.addChild(container);
		app.stage.addChild(sprite);
		app.ticker.add(allowInterop(
			(d) => app.renderer.render(container, rt))
		);
	}
}

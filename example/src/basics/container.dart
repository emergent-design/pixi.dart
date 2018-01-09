part of pixi.examples;


class ContainerExample extends Example
{
	Application app;
	final bool pivot;

	ContainerExample([this.pivot = false]);

	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(
			width: 800,
			height: 600,
			backgroundColor: 0x1099bb,
			view: canvas
		));

		var container = new Container();
		app.stage.addChild(container);

		for (int j=0; j<5; j++)
		{
			for (int i=0; i<5; i++)
			{
				var bunny = Sprite.fromImage('assets/basics/bunny.png')
					..x	= 40 * i
					..y	= 40 * j;

				container.addChild(bunny);
			}
		}

		container.x			= app.screen.width / 2;
		container.y			= app.screen.height / 2;
		container.pivot.x	= container.width / 2;
		container.pivot.y	= container.height / 2;

		if (this.pivot)
		{
			app.ticker.add(allowInterop(
				(d) => container.rotation -= 0.01 * d
			));
		}
	}
}

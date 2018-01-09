part of pixi.examples;


class AlphaMaskDemo extends Example
{
	Application app;


	void run(CanvasElement canvas)
	{
		this.app	= new Application(new Options(view: canvas));
		var target	= new Point();
		var reset	= () => target.set(
			(random.nextDouble() * 500).floor(),
			(random.nextDouble() * 300).floor()
		);

		var mask = Sprite.fromImage('assets/demos/flowerTop.png')
			..anchor.set(0.5)
			..x = 310
			..y = 190;

		app.stage.addChild(
			Sprite.fromImage('assets/demos/bkg.jpg'),
			mask,
			Sprite.fromImage('assets/demos/cells.png')
				..scale.set(1.5)
				..mask = mask
		);

		reset();
		app.ticker.add(allowInterop((_) {
			mask.x += (target.x - mask.x) * 0.1;
			mask.y += (target.y - mask.y) * 0.1;

			if ((mask.x - target.x).abs() < 1)
			{
				reset();
			}
		}));
	}
}
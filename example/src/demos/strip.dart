part of pixi.examples;


class StripDemo extends Example
{
	Application app;
	List<Point> points;

	double count = 0.0;
	static const double ropeLength = 918 / 20;


	void run(CanvasElement canvas)
	{
		this.app	= new Application(new Options(view: canvas));
		this.points	= new List.generate(20, (i) => new Point(i * ropeLength, 0));
		var strip	= new Rope(Texture.fromImage('assets/basics/snake.png'), this.points)
			..x = -459;

		app.stage.addChild(new Container()
			..addChild(strip)
			..scale.set(800 / 1100)
			..x = 400
			..y = 300
		);

		app.ticker.add(allowInterop((_) {
			count += 0.1;

			for (int i=0; i<points.length; i++)
			{
				points[i].set(
					i * ropeLength + cos((i * 0.3) + count) * 20,
					sin((i * 0.5) + count) * 30
				);
			}
		}));
	}
}
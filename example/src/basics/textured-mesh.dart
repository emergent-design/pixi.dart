part of pixi.examples;


class TexturedMeshExample extends Example
{
	Application app;
	Graphics graphics;
	List<Point> points;

	double count			= 0.0;
	final num ropeLength	= 45;


	void run(CanvasElement canvas)
	{
		this.app	= new Application(new Options(view: canvas));
		this.points	= new List.generate(25, (i) => new Point(i * ropeLength, 0));
		var strip	= new Rope(Texture.fromImage('assets/basics/snake.png'), points)
			..position.x = -40
			..position.y = 300;

		this.graphics = new Graphics()
			..x = strip.x
			..y = strip.y;


		app.stage.addChild(strip);
		app.stage.addChild(this.graphics);
		app.ticker.add(allowInterop(this.animate));
	}


	void animate(num d)
	{
		count += 0.1;
		for (int i=0; i<this.points.length; i++)
		{
			this.points[i]
				..y = sin(0.5 * i + count) * 30
				..x = i * ropeLength + cos(0.3 * i + count) * 20;
		}

		this.renderPoints();
	}


	void renderPoints()
	{
		this.graphics
			.clear()
			.lineStyle(2, 0xffc2c2)
			.moveTo(this.points[0].x, this.points[0].y);

		for (int i=1; i<points.length; i++)
		{
			this.graphics.lineTo(points[i].x, points[i].y);
		}

		for (int i=1; i<points.length; i++)
		{
			this.graphics
				.beginFill(0xff0022)
				.drawCircle(points[i].x, points[i].y, 10)
				.endFill();
		}
	}
}


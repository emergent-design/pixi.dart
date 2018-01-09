part of pixi.examples;


class GraphicsDemo extends Example
{
	Application app;
	Graphics graphics;
	Graphics thing;
	double count = 0.0;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(
			width: 800,
			height: 600,
			antialias: true,
			view: canvas
		));

		app.stage.interactive = true;

		this.graphics = new Graphics()
			.beginFill(0xFF3300)
			.lineStyle(10, 0xffd900, 1)

			// draw a shape
			.moveTo(50,50)
			.lineTo(250, 50)
			.lineTo(100, 100)
			.lineTo(250, 220)
			.lineTo(50, 220)
			.lineTo(50, 50)
			.endFill()

			// set a fill and line style again
			.lineStyle(10, 0xFF0000, 0.8)
			.beginFill(0xFF700B, 1)

			// draw a second shape
			.moveTo(210,300)
			.lineTo(450,320)
			.lineTo(570,350)
			.quadraticCurveTo(600, 0, 480,100)
			.lineTo(330,120)
			.lineTo(410,200)
			.lineTo(210,300)
			.endFill()

			// draw a rectangle
			.lineStyle(2, 0x0000FF, 1)
			.drawRect(50, 250, 100, 100)

			// draw a circle
			.lineStyle(0)
			.beginFill(0xFFFF0B, 0.5)
			.drawCircle(470, 200,100)
			.endFill()

			.lineStyle(20, 0x33FF00)
			.moveTo(30,30)
			.lineTo(600, 300);

		this.thing = new Graphics()
			..x = app.screen.width / 2
			..y = app.screen.height / 2;

		app.stage.addChild(this.graphics);
		app.stage.addChild(this.thing);
		app.stage.on('pointertap', allowInterop(onClick));
		app.ticker.add(allowInterop(animate));
	}

	void onClick(PixiEvent)
	{
		this.graphics
			.lineStyle(random.nextDouble() * 30, random.nextDouble() * 0xffffff, 1)
			.moveTo(random.nextDouble() * 800, random.nextDouble() * 600)
			.bezierCurveTo(
				random.nextDouble() * 800, random.nextDouble() * 600,
				random.nextDouble() * 800, random.nextDouble() * 600,
				random.nextDouble() * 800, random.nextDouble() * 600
			);
	}

	void animate(num)
	{
		this.count += 0.1;

		this.thing
			.clear()
			.lineStyle(10, 0xff0000, 1)
			.beginFill(0xffff00, 0.5)
			.moveTo(-120 + sin(count) * 20, -100 + cos(count)* 20)
			.lineTo( 120 + cos(count) * 20, -100 + sin(count)* 20)
			.lineTo( 120 + sin(count) * 20, 100 + cos(count)* 20)
			.lineTo( -120 + cos(count)* 20, 100 + sin(count)* 20)
			.lineTo( -120 + sin(count) * 20, -100 + cos(count)* 20)
			.rotation = count * 0.1;
	}
}

part of pixi.examples;


class MaskingDemo extends Example
{
	Application app;
	Container container;
	Sprite bg, bgFront, light2, light1;
	Sprite panda;
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

		this.bg = Sprite.fromImage('assets/demos/BGrotate.jpg')
			..anchor.set(0.5)
			..x = app.screen.width / 2
			..y = app.screen.height / 2;

		this.container = new Container()
			..x = app.screen.width / 2
			..y = app.screen.height / 2;

		this.bgFront	= Sprite.fromImage('assets/demos/SceneRotate.jpg')..anchor.set(0.5);
		this.light2		= Sprite.fromImage('assets/demos/LightRotate2.png')..anchor.set(0.5);
		this.light1		= Sprite.fromImage('assets/demos/LightRotate1.png')..anchor.set(0.5);
		this.panda		= Sprite.fromImage('assets/demos/panda.png')..anchor.set(0.5);

		this.thing = new Graphics().lineStyle(0)
			..x = app.screen.width / 2
			..y = app.screen.height / 2;

		this.container.mask = this.thing;

		var help = new Text('Click or tap to turn masking on / off.', new TextStyle(
			fontFamily: 'Arial',
			fontSize: 12,
			fontWeight: 'bold',
			fill: 'white'
		));

		help..x = 10
			..y = app.screen.height - 26;

		container.addChild(this.bgFront, this.light2, this.light1, this.panda);
		app.stage.addChild(this.bg, this.container, this.thing, help);
		app.stage.on('pointertap', allowInterop(onClick));
		app.ticker.add(allowInterop(animate));
	}

	void onClick(PixiEvent e)
	{
		this.container.mask = this.container.mask == null ? this.thing : null;
	}

	void animate(num d)
	{
		this.bg.rotation += 0.01;
		this.bgFront.rotation -= 0.01;
		this.light1.rotation += 0.02;
		this.light2.rotation += 0.01;
		this.panda.scale.set(
			1 + sin(count) * 0.04,
			1 + cos(count) * 0.04
		);

		count += 0.1;
		this.thing
			.clear()
			.beginFill(0x8bc5ff, 0.4)
			.moveTo(-120 + sin(count) * 20, -100 + cos(count)* 20)
			.lineTo(120 + cos(count) * 20, -100 + sin(count)* 20)
			.lineTo(120 + sin(count) * 20, 100 + cos(count)* 20)
			.lineTo(-120 + cos(count)* 20, 100 + sin(count)* 20)
			.rotation = count * 0.1;
	}
}

part of pixi.examples;


class ClickExample extends Example
{
	Application app;
	Sprite sprite;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(
			width: 800,
			height: 600,
			backgroundColor: 0x1099bb,
			view: canvas,
		));

		this.sprite	= Sprite.fromImage('assets/basics/bunny.png')
			..anchor.set(0.5)
			..position.set(app.screen.width / 2, app.screen.height / 2)
			..interactive = true
			..buttonMode = true
			..on('pointerdown', allowInterop(this.onDown));

		app.stage.addChild(this.sprite);
	}


	void onDown(PixiEvent e)
	{
		this.sprite.scale
			..x *= 1.25
			..y *= 1.25;
	}
}


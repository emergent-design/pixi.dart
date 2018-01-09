part of pixi.examples;


class BasicsExample extends Example
{
	Application app;
	Sprite bunny;
	final bool transparent;

	BasicsExample([this.transparent = false]);

	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(
			width: 800,
			height: 600,
			backgroundColor: this.transparent ? 0 : 0x1099bb,
			transparent: this.transparent,
			view: canvas
		));

		this.bunny = Sprite.fromImage('assets/basics/bunny.png')
			..anchor.set(0.5)
			..position.x = app.screen.width / 2
			..position.y = app.screen.height / 2;

		app.stage.addChild(this.bunny);
		app.ticker.add(allowInterop(
			(d) => this.bunny.rotation += 0.1 * d)
		);
	}
}

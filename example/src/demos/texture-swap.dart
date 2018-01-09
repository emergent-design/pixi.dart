part of pixi.examples;


class TextureSwapDemo extends Example
{
	Application app;


	void run(CanvasElement canvas)
	{
		this.app	= new Application(new Options(view: canvas));

		var textures = [
			Texture.fromImage('assets/demos/flowerTop.png'),
			Texture.fromImage('assets/demos/eggHead.png')
		];

		var dude = new Sprite(textures[0])
			..anchor.set(0.5)
			..x = app.screen.width / 2
			..y = app.screen.height / 2
			..interactive = true
			..buttonMode = true;

		app.stage.addChild(dude);
		app.ticker.add(allowInterop((_) => dude.rotation += 0.1));
		dude.on('pointertap', allowInterop((e) {
			dude.texture = dude.texture == textures[0] ? textures[1] : textures[0];
		}));
	}
}
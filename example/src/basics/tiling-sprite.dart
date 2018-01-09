part of pixi.examples;


class TilingSpriteExample extends Example
{
	Application app;
	TilingSprite tilingSprite;
	double count = 0.0;


	void run(CanvasElement canvas)
	{
		this.app			= new Application(new Options(view: canvas));
		var texture			= Texture.fromImage('assets/basics/p2.jpeg');
		this.tilingSprite	= new TilingSprite(texture, app.screen.width, app.screen.height);

		app.stage.addChild(this.tilingSprite);
		app.ticker.add(allowInterop(animate));
	}

	void animate(num)
	{
		this.count += 0.005;
		this.tilingSprite
			..tileScale.x = 2 + sin(this.count)
			..tileScale.y = 2 + cos(this.count)
			..tilePosition.x += 1
			..tilePosition.y += 1;
	}
}

part of pixi.examples;


class MaskingRenderTextureDemo extends Example
{
	Application app;
	Graphics brush;
	RenderTexture renderTexture;
	bool dragging = false;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(
			width: 800,
			height: 600,
			view: canvas
		));

		this.brush = new Graphics()
			.beginFill(0xffffff)
			.drawCircle(0, 0, 50)
			.endFill();

		new Loader()
			.add('t1', 'assets/basics/bkg-grass.jpg')
			.add('t2', 'assets/demos/BGrotate.jpg')
			.load(allowInterop(setup));
	}

	void setup(Loader loader, DynamicSource resources)
	{
		var r = new Dynamic<Resource>(resources);
		var background = new Sprite(r['t1'].texture)
			..width = app.screen.width
			..height = app.screen.height;

		var imageToReveal = new Sprite(r['t2'].texture)
			..width = app.screen.width
			..height = app.screen.height;

		this.renderTexture 		= RenderTexture.create(app.screen.width, app.screen.height);
		var renderTextureSprite	= new Sprite(renderTexture);
		imageToReveal.mask		= renderTextureSprite;

		app.stage.addChild(background, imageToReveal, renderTextureSprite);
		app.stage.interactive = true;
		app.stage.on('pointerdown', allowInterop(pointerDown));
		app.stage.on('pointerup', allowInterop(pointerUp));
		app.stage.on('pointermove', allowInterop(pointerMove));
	}

	void pointerDown(PixiEvent event)
	{
		this.dragging = true;
		this.pointerMove(event);
	}

	void pointerUp(PixiEvent)
	{
		this.dragging = false;
	}

	void pointerMove(PixiEvent event)
	{
		if (this.dragging)
		{
			this.brush.position.copy(event.data.global);
			app.renderer.render(this.brush, this.renderTexture, false, null, false);
		}
	}
}

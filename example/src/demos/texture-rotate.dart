part of pixi.examples;


class TextureRotateDemo extends Example
{
	Application app;


	void run(CanvasElement canvas)
	{
		this.app	= new Application(new Options(view: canvas));

		new Loader()
			..add('flowerTop', 'assets/demos/flowerTop.png')
			..load(allowInterop(init));
	}


	void init(Loader loader, DynamicSource resources)
	{
		Texture texture		= new Dynamic<Resource>(resources)['flowerTop'].texture;
		var textures	= [ texture ];

		for (int rotate = 1; rotate < 16; rotate++)
		{
			var frame	= texture.frame;
			var h		= GroupD8.isVertical(rotate) ? frame.width : frame.height;
			var w		= GroupD8.isVertical(rotate) ? frame.height : frame.width;
			var crop	= new Rectangle(frame.x, frame.y, w, h);
			var trim	= crop;	//crop.clone();

			if (rotate % 2 == 0)
			{
				textures.add(new Texture(texture.baseTexture, frame, crop, trim, rotate));
			}
			else
			{
				// HACK to avoid exception
				// PIXI doesnt like diamond-shaped UVs, because they are different in canvas and webgl
				textures.add(new Texture(texture.baseTexture, frame, crop, trim, rotate - 1)..rotate += 1);
			}
		}

		var offsetX = app.screen.width / 16;
		var offsetY = app.screen.height / 8;
		var gridW	= app.screen.width / 4;
		var gridH	= app.screen.height / 5;
		var style	= new TextStyle(
			fontFamily: 'Courier New',
			fontSize: '12px',
			fill: 'white',
			align: 'left'
		);

		for (int i=0; i<16; i++)
		{
			var dude = new Sprite(textures[i < 8 ? i*2 : (i-8)*2+1])
				..scale.set(0.5)
				..x = offsetX + gridW * (i % 4)
				..y = offsetY + gridH * (i ~/ 4 | 0);

			app.stage.addChild(
				dude,
				new Text("rotate = ${dude.texture.rotate}", style)
					..x = dude.x
					..y = dude.y - 20
			);
		}
	}
}
part of pixi.examples;


class DraggingDemo extends Example
{
	Application app;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(
			width: 800,
			height: 600,
			backgroundColor: 0x1099bb,
			view: canvas
		));

		var texture = Texture.fromImage('assets/basics/bunny.png')
			..baseTexture.scaleMode = SCALE_MODES.NEAREST;

		for (int i=0; i<10; i++)
		{
			app.stage.addChild(new Sprite(texture)
				..interactive = true
				..buttonMode = true
				..anchor.set(0.5)
				..scale.set(3)
				..position.set(random.nextDouble() * app.screen.width, random.nextDouble() * app.screen.height)
				..on('pointerdown', allowInteropCaptureThis(onDragStart))
				..on('pointerup', allowInteropCaptureThis(onDragEnd))
				..on('pointerupoutside', allowInteropCaptureThis(onDragEnd))
				..on('pointermove', allowInteropCaptureThis(onDragMove))
			);
		}
	}


	void onDragStart(Sprite self, PixiEvent event)
	{
		self.userdata	= event.data;
		self.alpha		= 0.5;
	}


	void onDragEnd(Sprite self, PixiEvent event)
	{
		self.userdata	= null;
		self.alpha		= 1.0;
	}


	void onDragMove(Sprite self, PixiEvent event)
	{
	 	var data = self.userdata as InteractionData;

		if (data != null)
		{
			self.position = data.getLocalPosition(self.parent);
		}
	}
}


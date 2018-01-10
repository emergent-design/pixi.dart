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
			var sprite = new Sprite(texture)
				..interactive = true
				..buttonMode = true
				..anchor.set(0.5)
				..scale.set(3)
				..position.set(random.nextDouble() * app.screen.width, random.nextDouble() * app.screen.height);

			sprite.on('pointerdown', allowInterop((e) {
				sprite.userdata = e.data;
				sprite.alpha	= 0.5;
			}));
			sprite.on('pointerup', allowInterop((e) {
				sprite.userdata	= null;
				sprite.alpha	= 1.0;
			}));
			sprite.on('pointerupoutside', allowInterop((e) {
				sprite.userdata	= null;
				sprite.alpha	= 1.0;
			}));
			sprite.on('pointermove', allowInterop((e) {
				InteractionData data = sprite.userdata;

				if (data != null)
				{
					sprite.position = data.getLocalPosition(sprite.parent);
				}
			}));

			app.stage.addChild(sprite);
		}
	}
}


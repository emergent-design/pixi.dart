part of pixi.examples;


class VideoExample extends Example
{
	Application app;
	Graphics button;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(
			width: 800,
			height: 600,
			transparent: true,
			view: canvas
		));

		this.button = new Graphics()
			.beginFill(0x0, 0.5)
			.drawRoundedRect(0, 0, 100, 100, 10)
			.endFill()
			.beginFill(0xffffff)
			.moveTo(36, 30)
			.lineTo(36, 70)
			.lineTo(70, 50);

		this.button
			..x = (app.screen.width - button.width) / 2
			..y = (app.screen.height - button.height) / 2
			..interactive = true
			..buttonMode = true
			..on('pointertap', allowInterop(onPlay));

		app.stage.addChild(this.button);
	}


	void onPlay(_)
	{
		this.button.destroy();

		var texture		= Texture.fromVideoUrl('assets/basics/testVideo.mp4');
		var videoSprite	= new Sprite(texture)
			..width = app.screen.width
			..height = app.screen.height;

		app.stage.addChild(videoSprite);
	}
}

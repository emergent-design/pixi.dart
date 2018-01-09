part of pixi.examples;


class InteractivityDemo extends Example
{
	Application app;


	void run(CanvasElement canvas)
	{
		this.app		= new Application(new Options(view: canvas));
		var background	= Sprite.fromImage("assets/demos/button_test_BG.jpg")
			..width		= app.screen.width
			..height	= app.screen.height;

		app.stage.addChild(background);

		List<Sprite> buttons = [];

		var positions = [
			new Point(175, 75),
			new Point(655, 75),
			new Point(410, 325),
	 		new Point(150, 465),
			new Point(685, 445)
		];

		var textures = {
			"button"	: Texture.fromImage("assets/demos/button.png"),
			"down"		: Texture.fromImage("assets/demos/buttonDown.png"),
			"over"		: Texture.fromImage("assets/demos/buttonOver.png")
		};

		for (int i=0; i<5; i++)
		{
			var button			= new Sprite(textures["button"]);
			button.anchor		= new Point(0.5, 0.5);
			button.position		= positions[i];
			button.interactive	= true;
			button.buttonMode	= true;
			bool isDown			= false;

			button.on('pointerdown',		allowInterop((e) { isDown = true;	button.texture = textures["down"]; }));
			button.on('pointerup',			allowInterop((e) { isDown = false;	button.texture = textures["over"]; }));
			button.on('pointerupoutside',	allowInterop((e) { isDown = false;	button.texture = textures["button"]; }));
			button.on('pointerover',		allowInterop((e) { if (!isDown) button.texture = textures["over"]; }));
			button.on('pointerout',			allowInterop((e) { if (!isDown) button.texture = textures["button"]; }));

			app.stage.addChild(button);
			buttons.add(button);
		}

		buttons[0].scale.set(1.2);
		buttons[2].rotation = PI / 10;
		buttons[3].scale.set(0.8);
		buttons[4].scale.set(0.8, 1.2);
		buttons[4].rotation = PI;
	}
}

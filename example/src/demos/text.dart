part of pixi.examples;


class TextDemo extends Example
{
	Application app;
	Text spinningText;
	Text countingText;
	num count = 0;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(view: canvas));

		WebFont.load(new WebFont.Config(
			google: new WebFont.Google(families: ['Snippet', 'Arvo:700italic', 'Podkova:700']),
			active: allowInterop(onInit)
		));
	}


	void onInit()
	{
		new Loader()
			.add('desyrel', 'assets/demos/desyrel.xml')
			.load(allowInterop(onAssetsLoaded));

		app.stage.addChild(
			Sprite.fromImage('assets/demos/textDemoBG.jpg')
				..width = app.screen.width
				..height = app.screen.height
		);

		var textSample = new Text('Pixi.js can has\n multiline text!', new TextStyle(
			fontFamily: 'Snippet',
			fontSize: 35,
			fill: 'white',
			align: 'left'
		))..position.set(20);

		this.spinningText = new Text("I'm fun!", new TextStyle(
			fontWeight: 'bold',
			fontSize: 60,
			fontFamily: 'Arial',
			fill: '#c0f',
			align: 'center',
			stroke: '#fff',
			strokeThickness: 6
		))..anchor.set(0.5)..position.set(app.screen.width / 2, app.screen.height / 2);

		this.countingText = new Text('COUNT 4EVAR: 0', new TextStyle(
			fontWeight: 'bold',
			fontStyle: 'italic',
			fontSize: 60,
			fontFamily: 'Arvo',
			fill: '#3e1707',
			align: 'center',
			stroke: '#a4410e',
			strokeThickness: 7
		))..position.set(app.screen.width / 2, 500)..anchor.x = 0.5;

		app.stage
			..addChild(textSample)
			..addChild(this.spinningText)
			..addChild(this.countingText);

		app.ticker.add(allowInterop(animate));
	}


	void onAssetsLoaded(Loader loader, DynamicSource resources)
	{
		var bitmapFontText = new BitmapText(
			'bitmap fonts are\n now supported!',
			new BitmapTextStyle(font: '35px Desyrel', align: 'right')
		);

		bitmapFontText.position.set(app.screen.width - bitmapFontText.textWidth - 20, 20);
		app.stage.addChild(bitmapFontText);
	}


	void animate(num)
	{
		this.count += 0.05;
		this.countingText.text = "COUNT 4EVAR: ${this.count.floor()}";
		this.spinningText.rotation += 0.03;
	}
}

import 'dart:html';
import 'package:pixi/pixi.dart';
import 'package:js/js.dart' as js;


class TextExample
{
	var renderer		= new CanvasRenderer(620, 400);
	var stage			= new Stage(new Colour.fromInt(0x66ff99));
	var loader 			= new AssetLoader([ 'desyrel.fnt' ]);
	var countingText	= null;
	var spinningText	= null;
	int count			= 0;
	int score			= 0;


	void start()
	{
		this.loader.onComplete.listen((c) {
			var bitmapText		= new BitmapText("bitmap fonts are\n now supported!", new Style(font: "35px Desyrel", align: Style.RIGHT));
			bitmapText.position = new Point(620 - bitmapText.width - 20, 20);

			this.stage.addChild(bitmapText);
		});

		document.body.append(this.renderer.view);

		// add a shiny background..
		var background = new Sprite.fromImage("textDemoBG.jpg");
		stage.addChild(background);

		// create some white text using the Snippet webfont
		var textSample = new CanvasText("Pixi.dart can has\nmultiline text!", new Style(
			font: "35px Snippet",
			fill: new Colour(255,255,255),
			align: Style.LEFT
		));

		textSample.position = new Point(20, 20);

		// create a text object with a nice stroke
		this.spinningText = new CanvasText("I'm fun!", new Style(
			font: "bold 60px Podkova",
			fill: new Colour.fromHtml('#cc00ff'),
			align: Style.CENTRE,
			stroke: new Colour(255,255,255),
			strokeThickness: 6
		));

		// setting the anchor point to 0.5 will center align the text... great for spinning!
		this.spinningText.anchor	= new Point(0.5, 0.5);
		this.spinningText.position	= new Point(620 / 2, 400 / 2);

		// create a text object that will be updated..
		this.countingText = new CanvasText("COUNT 4EVAR: 0", new Style(
			font: "bold italic 60px Arvo",
			fill: new Colour.fromHtml("#3e1707"),
			align: Style.CENTRE,
			stroke: new Colour.fromHtml("#a4410e"),
			strokeThickness: 7
		));

		this.countingText.position 	= new Point(620 / 2, 320);
		this.countingText.anchor	= new Point(0.5, 0.0);

		this.stage.addChild(textSample);
		this.stage.addChild(this.spinningText);
		this.stage.addChild(this.countingText);

		loader.load();

		window.requestAnimationFrame(this._animate);
	}


	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);

		if (this.count++ % 50 == 0)
		{
			// update the text...
			this.countingText.setText("COUNT 4EVAR: ${this.score++}");
		}

		// just for fun, lets rotate the text
		this.spinningText.rotation += 0.03;

		this.renderer.render(this.stage);
	}
}


void main()
{
	var text = new TextExample();

	js.context.WebFont.load(js.map({
		'google': { 'families': [ 'Snippet', 'Arvo:700italic', 'Podkova:700' ] },
		'active': text.start
	}));
}






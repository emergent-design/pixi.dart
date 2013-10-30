import 'dart:html';
import 'package:pixi/pixi.dart';
import 'package:js/js.dart' as js;


var renderer	= new CanvasRenderer(620, 400);
var stage		= new Stage(new Colour.fromInt(0x66ff99));
int count		= 0;
int score		= 0;
var countingText = null;
var spinningText = null;


void main()
{
	js.context.WebFont.load(js.map({
		'google': { 'families': [ 'Snippet', 'Arvo:700italic', 'Podkova:700' ] },
		'active': init
	}));
}


void init()
{
	var loader = new AssetLoader([ 'desyrel.fnt' ]);

	loader.onComplete.listen((c) {

		var bitmapText		= new BitmapText("bitmap fonts are\n now supported!", new Style(font: "35px Desyrel", align: Style.RIGHT));
		bitmapText.position = new Point(620 - bitmapText.width - 20, 20);

		stage.addChild(bitmapText);
	});


	document.body.append(renderer.view);

	// add a shiney background..
	var background = new Sprite.fromImage("textDemoBG.jpg");
	stage.addChild(background);

	// create some white text using the Snippet webfont
	var textSample = new CanvasText("Pixi.js can has\nmultiline text!", new Style(
		font: "35px Snippet",
		fill: new Colour(255,255,255),
		align: Style.LEFT
	));

	textSample.position = new Point(20, 20);

	// create a text object with a nice stroke
	spinningText = new CanvasText("I'm fun!", new Style(
		font: "bold 60px Podkova",
		fill: new Colour.fromHtml('#cc00ff'),
		align: Style.CENTRE,
		stroke: new Colour(255,255,255),
		strokeThickness: 6
	));

	// setting the anchor point to 0.5 will center align the text... great for spinning!
	spinningText.anchor		= new Point(0.5, 0.5);
	spinningText.position	= new Point(620 / 2, 400 / 2);

	// create a text object that will be updated..
	countingText = new CanvasText("COUNT 4EVAR: 0", new Style(
		font: "bold italic 60px Arvo",
		fill: new Colour.fromHtml("#3e1707"),
		align: Style.CENTRE,
		stroke: new Colour.fromHtml("#a4410e"),
		strokeThickness: 7
	));

	countingText.position 	= new Point(620 / 2, 320);
	countingText.anchor		= new Point(0.5, 0.0);

	stage.addChild(textSample);
	stage.addChild(spinningText);
	stage.addChild(countingText);

	loader.load();

	window.requestAnimationFrame(animate);
}

void animate(var num)
{
	window.requestAnimationFrame(animate);

	count++;
	if(count == 50)
	{
		count = 0;
		score++;

		// update the text...
		countingText.setText("COUNT 4EVAR: $score");
	}

	// just for fun, lets rotate the text
	spinningText.rotation += 0.03;

	renderer.render(stage);
}


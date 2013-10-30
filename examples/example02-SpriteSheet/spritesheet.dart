import 'dart:html';
import 'package:pixi/pixi.dart';
import 'dart:math';


var renderer		= new CanvasRenderer(800, 600);
var stage			= new Stage();
var alienContainer	= new DisplayObjectContainer();
var alienFrames		= [ "eggHead.png", "flowerTop.png", "helmlok.png", "skully.png" ];
List<Sprite> aliens	= [];
double count		= 0.0;


void main()
{
	var loader = new AssetLoader([ 'SpriteSheet.json' ]);
	var random = new Random();

	loader.onProgress.listen((p) => print(p));
	loader.onComplete.listen((c) {

		for (int i = 0; i < 100; i++)
		{
			var name	= alienFrames[i % 4];
			var alien 	= new Sprite.fromFrame(name);

			alien.position	= new Point(random.nextInt(800) - 400, random.nextInt(600) - 300);
			alien.anchor	= new Point(0.5, 0.5);
			aliens.add(alien);
			alienContainer.addChild(alien);
		}
		window.requestAnimationFrame(animate);
	});

	loader.load();

	document.body.append(renderer.view);

	alienContainer.position = new Point(400, 300);
	stage.addChild(alienContainer);
}


void animate(var num)
{
	window.requestAnimationFrame(animate);

	for (var a in aliens) a.rotation += 0.1;

	count += 0.01;
	alienContainer.scale = new Point(sin(count), sin(count));
	alienContainer.rotation += 0.01;

	renderer.render(stage);
}

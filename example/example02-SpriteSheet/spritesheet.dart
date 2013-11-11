import 'dart:html';
import 'dart:math';
import 'package:pixi/pixi.dart';


class SpriteSheetExample
{
	//var renderer		= new CanvasRenderer(width: 800, height: 600);
	var renderer		= new WebGLRenderer(width: 800, height: 600);
	var stage			= new Stage();
	var alienContainer	= new DisplayObjectContainer();
	var alienFrames		= [ "eggHead.png", "flowerTop.png", "helmlok.png", "skully.png" ];
	List<Sprite> aliens	= [];
	double count		= 0.0;


	SpriteSheetExample()
	{
		var loader = new AssetLoader([ 'SpriteSheet.json' ]);

		loader.onComplete.listen((c) => this._onLoaded());

		document.body.append(this.renderer.view);

		this.alienContainer.position = new Point(400, 300);

		this.stage.children.add(this.alienContainer);

		loader.load();
	}


	void _onLoaded()
	{
		var random = new Random();

		for (int i = 0; i < 100; i++)
		{
			var alien = new Sprite.fromFrame(this.alienFrames[i % 4])
				..position	= new Point(random.nextInt(800) - 400, random.nextInt(600) - 300)
				..anchor	= new Point(0.5, 0.5);

			this.aliens.add(alien);
			this.alienContainer.children.add(alien);
		}

		window.requestAnimationFrame(this._animate);
	}


	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);

		for (var a in this.aliens) a.rotation += 0.1;

		count += 0.01;
		this.alienContainer.scale = new Point(sin(count), sin(count));
		this.alienContainer.rotation += 0.01;

		this.renderer.render(this.stage);
	}
}


void main()
{
	new SpriteSheetExample();
}


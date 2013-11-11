import 'dart:html';
import 'dart:math';
import 'package:pixi/pixi.dart';


class MovieClipExample
{
	//var renderer		= new CanvasRenderer(width: 800, height: 600);
	var renderer		= new WebGLRenderer(width: 800, height: 600);
	var stage			= new Stage();


	MovieClipExample()
	{
		document.body.append(this.renderer.view);

		new AssetLoader([ 'SpriteSheet.json' ])
			..onComplete.listen((c) => this._onLoaded())
			..load();
	}


	void _onLoaded()
	{
		var random = new Random();
		List<Texture> textures = [];

		for (int i=0; i<27; i++)
		{
			textures.add(new Texture.fromFrame("Explosion_Sequence_A ${i+1}.png"));
		}

		for (int i=0; i<50; i++)
		{
			var scale = 0.75 + random.nextDouble() * 0.5;
			var speed = 0.75 + random.nextDouble() * 0.5;

			var explosion = new MovieClip(textures)
				..position			= new Point(random.nextInt(800), random.nextInt(600))
				..anchor			= new Point(0.5, 0.5)
				..rotation			= random.nextDouble() * PI
				..scale				= new Point(scale, scale)
				..animationSpeed	= speed
				..onComplete.listen((c) => print("complete"))
				..gotoAndPlay(random.nextInt(28));

			this.stage.children.add(explosion);
		}

		window.requestAnimationFrame(this._animate);
	}


	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);

		this.renderer.render(this.stage);
	}
}


void main()
{
	new MovieClipExample();
}


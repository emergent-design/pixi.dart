import 'dart:html';
import 'dart:math';
import 'package:pixi/pixi.dart';


class Star
{
	Sprite sprite;
	num x;
	num y;

	Star(this.sprite, this.x, this.y);
}


class BallsExample
{
	//var renderer			= new CanvasRenderer(width: 1024, height: 768);
	var renderer			= new WebGLRenderer(width: 1024, height: 768);
	var stage				= new Stage(new Colour(0, 0, 0));
	Random random			= new Random();
	List<Star> stars		= [];
	static const STARCOUNT	= 2500;

	int width, height, slideX, slideY;
	double sx, sy;


	BallsExample()
	{
		document.body.append(this.renderer.view);

		this._resize();
		this._newWave();

		var texture = new Texture.fromImage("assets/bubble_32x32.png");

		for (int i=0; i<STARCOUNT; i++)
		{
			var ball = new Sprite(texture)
				..position	= new Point(this.random.nextInt(this.width) - this.slideX, this.random.nextInt(this.height) - this.slideY)
				..anchor	= new Point(0.5, 0.5);

			this.stars.add(new Star(ball, ball.position.x, ball.position.y));
			this.stage.children.add(ball);
		}

		window.onResize.listen((t) => this._resize());
		document.querySelector("#rnd").onClick.listen((t) => this._newWave());

		window.requestAnimationFrame(this._animate);

	}

	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);

		for (var s in this.stars)
		{
			s.sprite.position = new Point(s.x + slideX, s.y + slideY);
			s.x *= this.sx;
			s.y *= this.sy;

			if (s.x > this.width)			s.x -= this.width;
			else if (s.x < -this.width)		s.x += this.width;
			if (s.y > this.height)			s.y -= this.height;
			else if (s.y < -this.height)	s.y += this.height;
		}

		this.renderer.render(this.stage);
	}


	void _resize()
	{
		this.width	= window.innerWidth - 16;
		this.height	= window.innerHeight - 16;
		this.slideX = this.width ~/ 2;
		this.slideY = this.height ~/ 2;

		this.renderer.resize(this.width, this.height);
	}

	void _newWave ()
	{
		this.sx = 1.0 + (this.random.nextDouble() / 20);
		this.sy = 1.0 + (this.random.nextDouble() / 20);

		document.querySelector("#sx").setInnerHtml("SX: ${this.sx}<br />SY: ${this.sy}");
	}
}


void main()
{
	new BallsExample();
}

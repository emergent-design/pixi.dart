import 'dart:html';
import 'dart:math';
import 'package:pixi/pixi.dart';


class Bunny extends Sprite
{
	bool dragging = false;

	Bunny(Texture texture) : super(texture);
}


class DraggingExample
{
	//var renderer	= new CanvasRenderer(width: 400, height: 300, interactive: true);
	var renderer		= new WebGLRenderer(width: window.innerWidth, height: window.innerHeight, interactive: true);
	var stage			= new Stage(new Colour.fromHtml('#97c56e'));
	var bunny			= new Texture.fromImage("bunny.png");
	Random random		= new Random();


	DraggingExample()
	{
		document.body.append(this.renderer.view);
		this.renderer.view.style
			..position	= "absolute"
			..top		= "0"
			..left		= "0";

		for (int i=0; i<10; i++)
		{
			this.createBunny(this.random.nextDouble() * window.innerWidth, this.random.nextDouble() * window.innerHeight);
		}


		window.requestAnimationFrame(this._animate);
	}


	void createBunny(double x, double y)
	{
		var bunny 		= new Bunny(this.bunny)
			..anchor 	= new Point(0.5, 0.5)
			..scale		= new Point(3, 3)
			..position	= new Point(x, y);

		bunny.onMouseDown.listen((e)	{ bunny.alpha = 0.9; bunny.dragging = true; });
		bunny.onTouchStart.listen((e)	{ bunny.alpha = 0.9; bunny.dragging = true; });
		bunny.onMouseUp.listen((e) 		{ bunny.alpha = 1.0; bunny.dragging = false; });
		bunny.onTouchEnd.listen((e) 	{ bunny.alpha = 1.0; bunny.dragging = false; });
		bunny.onMouseMove.listen((e)	{ if (bunny.dragging) bunny.position = new Point(e.x, e.y); });
		bunny.onTouchMove.listen((e)	{ if (bunny.dragging) bunny.position = new Point(e.x, e.y); });

		this.stage.children.add(bunny);
	}


	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);
		this.renderer.render(this.stage);
	}
}


void main()
{
	new DraggingExample();
}

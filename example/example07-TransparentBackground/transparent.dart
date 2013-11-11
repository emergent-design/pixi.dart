import 'dart:html';
import 'package:pixi/pixi.dart';


class TransparentExample
{
	//var renderer	= new CanvasRenderer(width: 400, height: 300, transparent: true);
	var renderer	= new WebGLRenderer(width: 400, height: 300, transparent: true);
	var stage		= new Stage(new Colour.fromHtml('#6f9'));
	var bunny		= new Sprite.fromImage("bunny.png");


	TransparentExample()
	{
		document.body.append(this.renderer.view);
		this.renderer.view
			..style.position 	= "absolute"
			..style.top 		= "0"
			..style.left		= "0";

		this.bunny.anchor 	= new Point(0.5, 0.5);
		this.bunny.position	= new Point(200, 150);

		this.stage.children.add(this.bunny);

		window.requestAnimationFrame(this._animate);
	}


	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);

		this.bunny.rotation += 0.1;

		this.renderer.render(this.stage);
	}
}


void main()
{
	new TransparentExample();
}

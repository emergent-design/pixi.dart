import 'dart:html';
import 'package:pixi/pixi.dart';


var renderer	= new CanvasRenderer(400, 300);
var stage		= new Stage(new Colour.fromHtml('#6f9'));
var bunny		= new Sprite.fromImage("bunny.png");


void main()
{
	document.body.append(renderer.view);

	bunny.anchor 	= new Point(0.5, 0.5);
	bunny.position	= new Point(200, 150);

	stage.addChild(bunny);

	window.requestAnimationFrame(animate);
}


void animate(var num)
{
	window.requestAnimationFrame(animate);

	bunny.rotation += 0.1;

	renderer.render(stage);
}

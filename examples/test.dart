import 'dart:html';
import 'package:pixi/pixi.dart';


var renderer	= new CanvasRenderer(800, 600, querySelector("#canvas"));
var stage		= new Stage();
var graphics	= new Graphics();


void main()
{
	/*Mat3 a = new Mat3.from([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
	Mat3 b = new Mat3.from([ 9, 8, 7, 6, 5, 4, 3, 2, 1 ]);

	var c = a * b;

	print("${c[0]}, ${c[1]}, ${c[2]}");
	print("${c[3]}, ${c[4]}, ${c[5]}");
	print("${c[6]}, ${c[7]}, ${c[8]}");*/


	stage.addChild(graphics);

	graphics.position	= new Point(300, 300);
	graphics.pivot 		= new Point(50, 50);
	graphics.lineStyle(1, new Colour.fromHtml('#f00'), 1.0);
	graphics.beginFill(new Colour.fromHtml('#f00'), 0.1);
	graphics.drawRect(0, 0, 100, 100);
	graphics.endFill();

	window.requestAnimationFrame(animate);

	/*var c = new Colour.fromHtml('#01f304');
	print(c.html);
	print(c.rgb);
	print(c.integer);
	print(c.integer.toRadixString(16));*/

}


void animate(var num)
{
	window.requestAnimationFrame(animate);

	graphics.rotation += 0.01;

	renderer.render(stage);
}
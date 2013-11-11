import 'dart:html';
import 'package:pixi/pixi.dart';


class TestExample
{
	//var renderer	= new CanvasRenderer(width: 800, height: 600, view: querySelector("#canvas"));
	var renderer	= new WebGLRenderer(width: 800, height: 600, view: querySelector("#canvas"), antialias: true);
	var stage		= new Stage(new Colour(220, 220, 255));
	var graphics	= new Graphics();


	TestExample()
	{
		this.stage.children.add(this.graphics);

		this.graphics
			..position	= new Point(300, 300)
			..pivot 	= new Point(50, 50)
			..lineStyle(1, new Colour.fromHtml('#f00'), 1.0)
			..beginFill(new Colour.fromHtml('#f00'), 0.1)
			..drawRect(0, 0, 100, 100)
			..endFill();

		window.requestAnimationFrame(this._animate);
	}


	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);

		this.graphics.rotation += 0.01;

		this.renderer.render(this.stage);
	}
}



void main()
{
	new TestExample();
	/*Mat3 a = new Mat3.from([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
	Mat3 b = new Mat3.from([ 9, 8, 7, 6, 5, 4, 3, 2, 1 ]);

	var c = a * b;

	print("${c[0]}, ${c[1]}, ${c[2]}");
	print("${c[3]}, ${c[4]}, ${c[5]}");
	print("${c[6]}, ${c[7]}, ${c[8]}");*/

	/*var g = new Graphics()
			// set a fill and line style
			..beginFill(new Colour.fromInt(0xFF3300))
			..lineStyle(10, new Colour.fromInt(0xffd900), 1.0)

			// draw a shape
			..moveTo(50,50)
			..lineTo(250, 50)
			..lineTo(100, 100)
			..lineTo(250, 220)
			..lineTo(50, 220)
			..lineTo(50, 50)
			..endFill();

	stage.addChild(g);
	stage.addChild(graphics);

	graphics.position	= new Point(300, 300);
	graphics.pivot 		= new Point(50, 50);
	graphics.lineStyle(1, new Colour.fromHtml('#f00'), 1.0);
	graphics.beginFill(new Colour.fromHtml('#f00'), 0.1);
	graphics.drawRect(0, 0, 100, 100);
	graphics.endFill();

	window.requestAnimationFrame(animate);*/

	/*var c = new Colour.fromHtml('#01f304');
	print(c.html);
	print(c.rgb);
	print(c.integer);
	print(c.integer.toRadixString(16));*/

}

/*
void animate(var num)
{
	window.requestAnimationFrame(animate);

	graphics.rotation += 0.01;

	renderer.render(stage);
}

*/
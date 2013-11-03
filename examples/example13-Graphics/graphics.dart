import 'dart:html';
import 'package:pixi/pixi.dart';
import 'dart:math';


class GraphicsExample
{
	//var renderer	= new CanvasRenderer(width: 620, height: 380);
	var renderer	= new WebGLRenderer(width: 620, height: 380, antialias: true);
	var stage		= new Stage(new Colour(255,255,255), true);
	var thing		= new Graphics();
	var count		= 0;


	GraphicsExample()
	{
		document.body.append(this.renderer.view);

		var random		= new Random();
		var graphics	= new Graphics()
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
			..endFill()

			// set a fill and line style again
			..lineStyle(10, new Colour.fromInt(0xFF0000), 0.8)
			..beginFill(new Colour.fromInt(0xFF700B), 1.0)

			// draw a second shape
			..moveTo(210,300)
			..lineTo(450,320)
			..lineTo(570,350)
			..lineTo(580,20)
			..lineTo(330,120)
			..lineTo(410,200)
			..lineTo(210,300)
			..endFill()

			// draw a rectangle
			..lineStyle(2, new Colour.fromInt(0x0000FF), 1.0)
			..drawRect(50, 250, 100, 100)

			// draw a circle
			..lineStyle(0)
			..beginFill(new Colour.fromInt(0xFFFF0B), 0.5)
			..drawCircle(470, 200,100)

			// and one last line
			..lineStyle(20, new Colour.fromInt(0x33FF00))
			..moveTo(30,30)
			..lineTo(600, 300);


		stage.addChild(graphics);
		stage.addChild(this.thing);

		this.thing.position = new Point(620 / 2, 380 / 2);

		// TODO: Interactive
		//thing.onClick...

		window.requestAnimationFrame(this._animate);
	}


	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);

		this.count += 0.1;
		this.thing
			..clear()
			..lineStyle(30, new Colour.fromInt(0xff0000), 1.0)
			..beginFill(new Colour.fromInt(0xffFF00), 0.5)
			..moveTo(-120 + sin(count) * 20, -100 + cos(count)* 20)
			..lineTo(120 + cos(count) * 20, -100 + sin(count)* 20)
			..lineTo(120 + sin(count) * 20, 100 + cos(count)* 20)
			..lineTo(-120 + cos(count)* 20, 100 + sin(count)* 20)
			..lineTo(-120 + sin(count) * 20, -100 + cos(count)* 20)
			..rotation = this.count * 0.1;

		this.renderer.render(this.stage);
	}
}



void main()
{
	new GraphicsExample();
}
import 'dart:html';
import 'package:pixi/pixi.dart';
import 'dart:math';


// TODO enable anti-aliasing when webgl
var renderer	= new CanvasRenderer(620, 380);
var stage		= new Stage(new Colour(255,255,255), true);
var thing		= new Graphics();
var count		= 0;


void main()
{
	var random = new Random();

	document.body.append(renderer.view);

	var graphics = new Graphics();

	// set a fill and line style
	graphics.beginFill(new Colour.fromInt(0xFF3300));
	graphics.lineStyle(10, new Colour.fromInt(0xffd900), 1.0);

	// draw a shape
	graphics.moveTo(50,50);
	graphics.lineTo(250, 50);
	graphics.lineTo(100, 100);
	graphics.lineTo(250, 220);
	graphics.lineTo(50, 220);
	graphics.lineTo(50, 50);
	graphics.endFill();

	// set a fill and line style again
	graphics.lineStyle(10, new Colour.fromInt(0xFF0000), 0.8);
	graphics.beginFill(new Colour.fromInt(0xFF700B), 1.0);

	// draw a second shape
	graphics.moveTo(210,300);
	graphics.lineTo(450,320);
	graphics.lineTo(570,350);
	graphics.lineTo(580,20);
	graphics.lineTo(330,120);
	graphics.lineTo(410,200);
	graphics.lineTo(210,300);
	graphics.endFill();

	// draw a rectangel
	graphics.lineStyle(2, new Colour.fromInt(0x0000FF), 1.0);
	graphics.drawRect(50, 250, 100, 100);

	// draw a circle
	graphics.lineStyle(0);
	graphics.beginFill(new Colour.fromInt(0xFFFF0B), 0.5);
	graphics.drawCircle(470, 200,100);

	graphics.lineStyle(20, new Colour.fromInt(0x33FF00));
	graphics.moveTo(30,30);
	graphics.lineTo(600, 300);


	stage.addChild(graphics);
	stage.addChild(thing);

	thing.position = new Point(620 / 2, 380 / 2);

	// TODO: Interactive
	//thing.onClick...


	window.requestAnimationFrame(animate);
}


void animate(var num)
{
	thing.clear();

	count += 0.1;

	thing.lineStyle(30, new Colour.fromInt(0xff0000), 1.0);
	thing.beginFill(new Colour.fromInt(0xffFF00), 0.5);

	thing.moveTo(-120 + sin(count) * 20, -100 + cos(count)* 20);
	thing.lineTo(120 + cos(count) * 20, -100 + sin(count)* 20);
	thing.lineTo(120 + sin(count) * 20, 100 + cos(count)* 20);
	thing.lineTo(-120 + cos(count)* 20, 100 + sin(count)* 20);
	thing.lineTo(-120 + sin(count) * 20, -100 + cos(count)* 20);

	thing.rotation = count * 0.1;

	renderer.render(stage);
	window.requestAnimationFrame(animate);
}

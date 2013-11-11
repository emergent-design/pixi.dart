import 'dart:html';
import 'dart:math';

import 'package:pixi/pixi.dart';


class BenchmarkRecursion
{
	static const LEVELS = 12;
	static const SPRITES_PER_LEVEL = 4;

	//var renderer	= new CanvasRenderer(width: 1024, height: 768);
	var renderer	= new WebGLRenderer(width: 1024, height: 768);
	var stage		= new Stage(new Colour.fromHtml('#6f9'));
	var texture		= new Texture.fromImage("bunny.png");
	Random random	= new Random();
	//var bunny		= new Sprite.fromImage("bunny.png");

	double frameSum 	= 0.0;
	int frameCount		= 0;
	bool recursive		= false;

	BenchmarkRecursion()
	{
		document.body.append(this.renderer.view);

		//this.bunny.anchor 	= new Point(0.5, 0.5);
		//this.bunny.position	= new Point(200, 150);

		//this.stage.addChild(this.bunny);
		var text = new CanvasText("Some text", new Style());

		this.stage.children.add(this._addContainer(0));
		//this.stage.addChild(new Sprite.fromImage("bunny.png"));
		//this.stage.addChild(text);
		//this.stage.addChild(this._addContainer(0));

		//print("Number of children: ${this.stage.list.length}");

		window.requestAnimationFrame(this._animate);
	}


	DisplayObject _addContainer(int level)
	{
		var result = new DisplayObjectContainer();

		if (level < LEVELS) result.children.add(this._addContainer(level+1));

		for (int i=0; i<SPRITES_PER_LEVEL; i++)
		{
			result.children.add(new Sprite(this.texture)
				..anchor 	= new Point(0.5, 0.5)
				..position	= new Point(this.random.nextInt(1024), this.random.nextInt(768))
			);
		}

		if (level < LEVELS) result.children.add(this._addContainer(level+1));

		return result;
	}


	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);

		var start = window.performance.now();

		//if (recursive)	this.renderer.renderRecursive(this.stage);
		//else 			this.renderer.render(this.stage);
		this.renderer.render(this.stage);

		var end = window.performance.now();

		if (frameCount < 50)
		{
			frameCount++;
			frameSum += end - start;
		}
		else
		{
			print((recursive ? "Recursive: " : "Flat: ") + (frameSum / 50).toString());
			frameSum = end - start;
			frameCount = 1;
			recursive = !recursive;
		}
	}
}


void main()
{
	new BenchmarkRecursion();
}
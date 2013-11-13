import 'dart:html';
import 'dart:math';
import 'package:pixi/pixi.dart';
import 'package:js/js.dart' as js;


class Bunny extends Sprite
{
	Point speed;

	Bunny(Texture texture, { num width: 0, num height: 0 }) : super(texture, width: width, height: height);
}

class BunnyBench
{
	//Ordering sprites by their texture leads to better performance.
	//'best', 'worst', 'random', or a number for the max
	static const TEXTURE_BENCH = 'worst';
	static const START_BUNNIES = 400;

	//Renderer renderer		= new CanvasRenderer(width: 800, height: 600, view: querySelector("#canvas"));
	Renderer renderer		= new WebGLRenderer(width: 800, height: 600, view: querySelector("#canvas"), multibatch: true);
	Stage stage				= new Stage();
	Element counter			= querySelector("#counter");
	Random random			= new Random();

	num maxX		= 800;
	num minX		= 0;
	num maxY		= 600;
	num minY		= 0;
	num gravity		= 0.75;

	List<Texture> textures	= [];
	var bunnies				= [];

	var stats;

	bool isAdding = false;
	int count = 0;
	int step = 0;
	int amount = 10;


	BunnyBench()
	{
		this.renderer.view.style.position = 'absolute';

		this.stats = new js.Proxy(js.context.Stats);

		document.body.append(this.stats.domElement);
		this.stats.domElement.style.position = 'absolute';
		this.stats.domElement.style.top = '0';

		var urls = [
			"images/spinObj_01.png", "images/spinObj_02.png",
			"images/spinObj_03.png", "images/spinObj_04.png",
			"images/spinObj_05.png", "images/spinObj_06.png",
			"images/spinObj_07.png", "images/spinObj_08.png",
		];

		for (var u in urls)
		{
			this.textures.add(new Texture.fromImage(u));
		}

		this.count = START_BUNNIES;
		this.counter.setInnerHtml("${this.count} BUNNIES");

		for (int i=0; i<this.count; i++)
		{
			var texture = this.textures[this.getIndex(i)];
			var bunny	= new Bunny(texture, width: 48, height: 48)
				..position	= new Point(0, 0)
				..anchor	= new Point(0.5, 1.0)
				..speed		= new Point(this.random.nextDouble() * 10, this.random.nextDouble() * 10 - 5);

			this.bunnies.add(bunny);
			this.stage.children.add(bunny);
		}

		this.renderer.view.onMouseDown.listen((e) => this.isAdding = true);
		this.renderer.view.onMouseUp.listen((e) => this.isAdding = false);
		this.renderer.view.onTouchStart.listen((e) => this.isAdding = true);
		this.renderer.view.onTouchEnd.listen((e) => this.isAdding = false);

		this.resize();
		window.requestAnimationFrame(this.update);
	}


	void resize()
	{
		var ww		= window.innerWidth - 16;
		var wh		= window.innerHeight - 16;
		var width	= min(800, ww);
		var height	= min(600, wh);

		this.maxX = width;
		this.maxY = height;

		var w = ww / 2 - width / 2;
		var h = wh / 2 - height / 2;

		this.renderer.view.style.left	= "${w}px";
		this.renderer.view.style.top 	= "${h}px";

		this.stats.domElement.style.left	= "${w}px";
		this.stats.domElement.style.top		= "${h}px";

		this.counter.style.left = "${w}px";
		this.counter.style.top	= "${h + 49}px";

		querySelector("#pixi")
			..style.right = "${w}px"
			..style.bottom	= "${h + 8}px";

		querySelector("#clickImage")
			..style.right	= "${w + 108}px"
			..style.bottom	= "${h + 17}px";

		this.renderer.resize(width, height);
	}


	int getIndex(int i)
	{
		int length = this.textures.length;

		switch (TEXTURE_BENCH)
		{
			case 'worst':	return i % length;
			case 'random':	return this.random.nextInt(length);
			case 'best':	if (i % length == 0) step++;
							return step % textures.length;
			default:		return 0;
		}
	}


	void update(var frame)
	{
		this.stats.begin();

		if (this.isAdding)
		{
			for (int i=0; i<this.amount; this.count++, i++)
			{
				var texture = this.textures[this.getIndex(i)];
				var bunny	= new Bunny(texture, width: 48, height: 48)
					..position	= new Point(0, 0)
					..anchor	= new Point(0.5, 1.0)
					..speed		= new Point(this.random.nextDouble() * 10, this.random.nextDouble() * 10 - 5);

				this.bunnies.add(bunny);
				this.stage.children.add(bunny);
			}

			if (this.count >= 16500) this.amount = 0;

			this.counter.setInnerHtml("${this.count} BUNNIES");
		}

		for (Bunny bunny in this.bunnies)
		{
			num x	= bunny.position.x;
			num y	= bunny.position.y;
			num sx	= bunny.speed.x;
			num sy	= bunny.speed.y;

			x	+= sx;
			y	+= sy;
			sy	+= this.gravity;

			//Dirty sprites??

			if (x > this.maxX)
			{
				sx *= -1;
				x	= this.maxX;
			}
			else if (x < this.minX)
			{
				sx *= -1;
				x	= this.maxX;
			}

			if (y > this.maxY)
			{
				sy *= -0.85;
				y	= this.maxY;

				if (this.random.nextDouble() > 0.5) sy -= this.random.nextDouble() * 6;
			}
			else if (y < this.minY)
			{
				sy	= 0;
				y	= this.minY;
			}

			bunny.position	= new Point(x, y);
			bunny.speed		= new Point(sx, sy);
		}

		this.renderer.render(this.stage);
		window.requestAnimationFrame(this.update);

		this.stats.end();
	}
}


void main()
{
	new BunnyBench();
}



import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:pixi/pixi.dart';



class MorphExample
{
	static const POINTS		= 2000;
	static const OBJECTS	= 18;
	//var renderer			= new CanvasRenderer(width: 1024, height: 768);
	var renderer			= new WebGLRenderer(width: 1024, height: 768);
	var stage				= new Stage(new Colour(0, 0, 0));
	Random random			= new Random();
	double vx 				= 0.0;
	double vy 				= 0.0;
	double vz 				= 0.0;
	double distance			= 1.0;
	int current				= 1;

	List<double> pointX 		= new List<double>(POINTS);
	List<double> pointY 		= new List<double>(POINTS);
	List<double> pointZ 		= new List<double>(POINTS);
	List<double> transformedX 	= new List<double>(POINTS);
	List<double> transformedY 	= new List<double>(POINTS);
	List<double> transformedZ 	= new List<double>(POINTS);
	List<Sprite> pixels			= [];

	int width, height;


	MorphExample()
	{
		document.body.append(this.renderer.view);

		this._resize();

		var texture = new Texture.fromImage("assets/pixel.png");


		this._makeObject(0);

		for (int i=0; i<POINTS; i++)
		{
			this.transformedX[i] = this.pointX[i];
			this.transformedY[i] = this.pointY[i];
			this.transformedZ[i] = this.pointZ[i];

			var pixel = new Sprite(texture)
				..anchor 	= new Point(0.5, 0.5)
				..alpha		= 0.5;

			this.pixels.add(pixel);
			this.stage.addChild(pixel);
		}

		window.onResize.listen((t) => this._resize());

		new Timer.periodic(new Duration(seconds: 5), (t) => this._nextObject());
		//this.renderer.view.onClick.listen((e) => this._nextObject());

		window.requestAnimationFrame(this._animate);
	}


	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);

		if (this.distance < 250) this.distance++;

		this.vx += 0.0075;
		this.vy += 0.0075;
		this.vz += 0.0075;

		double x, y, z, tx, ty, tz, ox;

		double cx = cos(vx), cy = cos(vy), cz = cos(vz);
		double sx = sin(vx), sy = sin(vy), sz = sin(vz);

		for (int i=0; i<POINTS; i++)
		{
			if (pointX[i] > transformedX[i]) transformedX[i] += 1;
			if (pointX[i] < transformedX[i]) transformedX[i] -= 1;
			if (pointY[i] > transformedY[i]) transformedY[i] += 1;
			if (pointY[i] < transformedY[i]) transformedY[i] -= 1;
			if (pointZ[i] > transformedZ[i]) transformedZ[i] += 1;
			if (pointZ[i] < transformedZ[i]) transformedZ[i] -= 1;

			x = transformedX[i];
			y = transformedY[i];
			z = transformedZ[i];

			ty = y * cx - z * sx;
			tz = y * sx + z * cx;
			tx = x * cy - tz * sy;
			tz = x * sy + tz * cy;
			ox = tx;
			tx = tx * cz - ty * sz;
			ty = ox * sz + ty * cz;

			this.pixels[i].position = new Point(
				(512 * tx) / (this.distance - tz) + this.width / 2,
				this.height / 2 - (512 * ty) / (this.distance - tz)
			);
		}

		this.renderer.render(this.stage);
	}


	void _resize()
	{
		this.width	= window.innerWidth - 16;
		this.height	= window.innerHeight - 16;

		this.renderer.resize(this.width, this.height);
	}


	void _nextObject()
	{
		this._makeObject(this.current++ % OBJECTS);
	}


	void _makeObject(int type)
	{
		int i;
		double xd;
		var px 		= this.pointX;
		var py 		= this.pointY;
		var pz 		= this.pointZ;
		var r		= this.random;
		double a	= 360.0 / POINTS;

		switch (type)
		{
			case 0: for (i=0; i<POINTS; i++) {
						px[i] = -50.0 + r.nextInt(100);
						py[i] = 0.0;
						pz[i] = 0.0;
					}
					break;

			case 1: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(xd) * cos(a) * 100;
						py[i] = cos(xd) * sin(a) * 100;
						pz[i] = sin(xd) * 100;
					}
					break;

			case 2: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(xd) * cos(2 * a) * 100;
						py[i] = cos(xd) * sin(2 * a) * 100;
						pz[i] = sin(i * a) * 100;
					}
					break;

			case 3: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(xd) * cos(xd) * 100;
						py[i] = cos(xd) * sin(xd) * 100;
						pz[i] = sin(xd) * 100;
					}
					break;

			case 4: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(xd) * cos(xd) * 100;
						py[i] = cos(xd) * sin(xd) * 100;
						pz[i] = sin(i * a) * 100;
					}
					break;

			case 5: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(xd) * cos(xd) * 100;
						py[i] = cos(i * a) * sin(xd) * 100;
						pz[i] = sin(i * a) * 100;
					}
					break;

			case 6: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(i * a) * cos(i * a) * 100;
						py[i] = cos(i * a) * sin(xd) * 100;
						pz[i] = sin(i * a) * 100;
					}
					break;

			case 7: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(i * a) * cos(i * a) * 100;
						py[i] = cos(i * a) * sin(i * a) * 100;
						pz[i] = sin(i * a) * 100;
					}
					break;

			case 8: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(xd) * cos(i * a) * 100;
						py[i] = cos(i * a) * sin(i * a) * 100;
						pz[i] = sin(xd) * 100;
					}
					break;

			case 9: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(xd) * cos(i * a) * 100;
						py[i] = cos(i * a) * sin(xd) * 100;
						pz[i] = sin(xd) * 100;
					}
					break;

			case 10: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(i * a) * cos(i * a) * 100;
						py[i] = cos(xd) * sin(xd) * 100;
						pz[i] = sin(i * a) * 100;
					}
					break;

			case 11: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(xd) * cos(i * a) * 100;
						py[i] = sin(xd) * sin(i * a) * 100;
						pz[i] = sin(xd) * 100;
					}
					break;

			case 12: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(xd) * cos(xd) * 100;
						py[i] = sin(xd) * sin(xd) * 100;
						pz[i] = sin(i * a) * 100;
					}
					break;

			case 13: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(xd) * cos(i * a) * 100;
						py[i] = sin(i * a) * sin(xd) * 100;
						pz[i] = sin(i * a) * 100;
					}
					break;

			case 14: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = sin(xd) * cos(xd) * 100;
						py[i] = sin(xd) * sin(i * a) * 100;
						pz[i] = sin(i * a) * 100;
					}
					break;

			case 15: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(i * a) * cos(i * a) * 100;
						py[i] = sin(i * a) * sin(xd) * 100;
						pz[i] = sin(xd) * 100;
					}
					break;

			case 16: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(xd) * cos(i * a) * 100;
						py[i] = sin(i * a) * sin(xd) * 100;
						pz[i] = sin(xd) * 100;
					}
					break;

			case 17: for (i=0; i<POINTS; i++) {
						xd = -90.0 + r.nextInt(180);
						px[i] = cos(xd) * cos(xd) * 100;
						py[i] = cos(i * a) * sin(i * a) * 100;
						pz[i] = sin(i * a) * 100;
					}
					break;
		}
	}
}


void main()
{
	new MorphExample();
}


/*
	$(window).resize(resize)
	window.onorientationchange = resize;

	document.addEventListener('DOMContentLoaded', start, false);

	var w = 1024;
	var h = 768;

	var n = 2000;
	var d = 1;
	var current = 1;
	var objs = 17;
	var vx = 0;
	var vy = 0;
	var vz = 0;
	var points1 = [];
	var points2 = [];
	var points3 = [];
	var tpoint1 = [];
	var tpoint2 = [];
	var tpoint3 = [];
	var balls = [];

	function start() {

		var ballTexture = new PIXI.Texture.fromImage("assets/pixel.png");

		renderer = PIXI.autoDetectRenderer(w, h);

		stage = new PIXI.Stage;

		document.body.appendChild(renderer.view);

		makeObject(0);

		for (var i = 0; i < n; i++)
		{
			tpoint1[i] = points1[i];
			tpoint2[i] = points2[i];
			tpoint3[i] = points3[i];

			var tempBall = new PIXI.Sprite(ballTexture);
			tempBall.anchor.x = 0.5;
			tempBall.anchor.y = 0.5;
			tempBall.alpha = 0.5;
			balls[i] = tempBall;

			stage.addChild(tempBall);
		}

		resize();

		setTimeout(nextObject, 5000);

		requestAnimFrame(update);

	}

	function nextObject () {

		current++;

		if (current > objs)
		{
			current = 0;
		}

		makeObject(current);

		setTimeout(nextObject, 8000);

	}

	function makeObject ( t ) {

		var xd;

		switch (t)
		{
			case 0:

				for (var i = 0; i < n; i++)
				{
					points1[i] = -50 + Math.round(Math.random() * 100);
					points2[i] = 0;
					points3[i] = 0;
				}
				break;

			case 1:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(t * 360 / n) * 10);
					points2[i] = (Math.cos(xd) * 10) * (Math.sin(t * 360 / n) * 10);
					points3[i] = Math.sin(xd) * 100;
				}
				break;

			case 2:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(t * 360 / n) * 10);
					points2[i] = (Math.cos(xd) * 10) * (Math.sin(t * 360 / n) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;

			case 3:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10);
					points2[i] = (Math.cos(xd) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(xd) * 100;
				}
				break;

			case 4:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10);
					points2[i] = (Math.cos(xd) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;

			case 5:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10);
					points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;

			case 6:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(i * 360 / n) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;

			case 7:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(i * 360 / n) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(i * 360 / n) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;

			case 8:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(i * 360 / n) * 10);
					points3[i] = Math.sin(xd) * 100;
				}
				break;

			case 9:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(xd) * 100;
				}
				break;

			case 10:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(i * 360 / n) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.cos(xd) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;

			case 11:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.sin(xd) * 10) * (Math.sin(i * 360 / n) * 10);
					points3[i] = Math.sin(xd) * 100;
				}
				break;

			case 12:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10);
					points2[i] = (Math.sin(xd) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;

			case 13:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.sin(i * 360 / n) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;

			case 14:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.sin(xd) * 10) * (Math.cos(xd) * 10);
					points2[i] = (Math.sin(xd) * 10) * (Math.sin(i * 360 / n) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;

			case 15:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(i * 360 / n) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.sin(i * 360 / n) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;

			case 16:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(i * 360 / n) * 10);
					points2[i] = (Math.sin(i * 360 / n) * 10) * (Math.sin(xd) * 10);
					points3[i] = Math.sin(xd) * 100;
				}
				break;

			case 17:

				for (var i = 0; i < n; i++)
				{
					xd = -90 + Math.round(Math.random() * 180);
					points1[i] = (Math.cos(xd) * 10) * (Math.cos(xd) * 10);
					points2[i] = (Math.cos(i * 360 / n) * 10) * (Math.sin(i * 360 / n) * 10);
					points3[i] = Math.sin(i * 360 / n) * 100;
				}
				break;
		}

	}

	function resize()
	{
		w = $(window).width() - 16;
		h = $(window).height() - 16;

		renderer.resize(w, h);
	}

	function update()
	{
		var x3d, y3d, z3d, tx, ty, tz, ox;

		if (d < 250)
		{
			d++;
		}

		vx += 0.0075;
		vy += 0.0075;
		vz += 0.0075;

		for (var i = 0; i < n; i++)
		{
			if (points1[i] > tpoint1[i]) { tpoint1[i] = tpoint1[i] + 1; }
			if (points1[i] < tpoint1[i]) { tpoint1[i] = tpoint1[i] - 1; }
			if (points2[i] > tpoint2[i]) { tpoint2[i] = tpoint2[i] + 1; }
			if (points2[i] < tpoint2[i]) { tpoint2[i] = tpoint2[i] - 1; }
			if (points3[i] > tpoint3[i]) { tpoint3[i] = tpoint3[i] + 1; }
			if (points3[i] < tpoint3[i]) { tpoint3[i] = tpoint3[i] - 1; }

			x3d = tpoint1[i];
			y3d = tpoint2[i];
			z3d = tpoint3[i];

			ty = (y3d * Math.cos(vx)) - (z3d * Math.sin(vx));
			tz = (y3d * Math.sin(vx)) + (z3d * Math.cos(vx));
			tx = (x3d * Math.cos(vy)) - (tz * Math.sin(vy));
			tz = (x3d * Math.sin(vy)) + (tz * Math.cos(vy));
			ox = tx;
			tx = (tx * Math.cos(vz)) - (ty * Math.sin(vz));
			ty = (ox * Math.sin(vz)) + (ty * Math.cos(vz));

			balls[i].position.x = (512 * tx) / (d - tz) + w / 2;
			balls[i].position.y = (h/2) - (512 * ty) / (d - tz);

		}

		renderer.render(stage);

		requestAnimFrame(update);
	}
*/
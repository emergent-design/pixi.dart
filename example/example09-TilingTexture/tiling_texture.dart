import 'dart:html';
import 'dart:math';
import 'package:pixi/pixi.dart';


class TilingTextureExample
{
	//var renderer		= new CanvasRenderer(width: window.innerWidth, height: window.innerHeight);
	var renderer		= new WebGLRenderer(width: window.innerWidth, height: window.innerHeight);
	var stage			= new Stage(new Colour.fromInt(0x97c56e));
	double count		= 0.0;
	var tilingSprite	= null;



	TilingTextureExample()
	{
		document.body.append(this.renderer.view);

		this.renderer.view.style.position	= "absolute";
		this.renderer.view.style.top		= "0";
		this.renderer.view.style.left		= "0";

		var texture 		= new Texture.fromImage("p2.jpeg");
		this.tilingSprite 	= new TilingSprite(texture, window.innerWidth, window.innerHeight);


		this.stage.addChild(tilingSprite);
		//this.stage.addChild(new Sprite(texture));

		window.requestAnimationFrame(this._animate);
	}


	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);

		this.count += 0.005;

		var pos = this.tilingSprite.tilePosition;

		this.tilingSprite.tileScale 	= new Point(2 + sin(this.count), 2 + cos(this.count));
		this.tilingSprite.tilePosition	= new Point(pos.x + 1, pos.y + 1);

		this.renderer.render(this.stage);
	}
}


void main()
{
	new TilingTextureExample();
}

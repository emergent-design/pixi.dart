import 'dart:html';
import 'dart:math';
import 'package:pixi/pixi.dart';


class IteractivityExample
{
	//var renderer	= new CanvasRenderer(width: 400, height: 300, interactive: true);
	var renderer			= new WebGLRenderer(width: 620, height: 400, interactive: true);
	var stage				= new Stage(new Colour.fromHtml('#000'));
	var background			= new Sprite.fromImage("button_test_BG.jpg");
	List<Sprite> buttons	= new List<Sprite>();


	IteractivityExample()
	{
		document.body.append(this.renderer.view);

		this.stage.children.add(background);

		var positions = [
			new Point(175, 75),
			new Point(600-145, 75),
			new Point(600/2 - 20, 400/2 + 10),
	   		new Point(175, 400-75),
		 	new Point(600-115, 400-95)
		];

		var textures = {
			"button"	: new Texture.fromImage("button.png"),
			"down"		: new Texture.fromImage("buttonDown.png"),
			"over"		: new Texture.fromImage("buttonOver.png")
		};

		for (int i=0; i<5; i++)
		{
			var button			= new Sprite(textures["button"]);
			button.anchor		= new Point(0.5, 0.5);
			button.position		= positions[i];

			button.onMouseDown.listen((e) => button.setTexture(textures["down"]));
			button.onTouchStart.listen((e) => button.setTexture(textures["down"]));
			button.onMouseOver.listen((e) { if (!button.isDown) button.setTexture(textures["over"]); });
			button.onMouseOut.listen((e) { if (!button.isDown) button.setTexture(textures["button"]); });
			button.onTap.listen((e) => print("Tapped button $i"));
			button.onClick.listen((e) => print("Clicked button $i"));

			//button.hitArea = new HitRectangle(-10, -10, 20, 20);

			this.stage.children.add(button);
			this.buttons.add(button);
		}

		this.stage.onMouseUp.listen((e) {
			for (var b in this.buttons) b.setTexture(b.isOver ? textures["over"] : textures["button"]);
		});

		this.stage.onTouchEnd.listen((e) {
			for (var b in this.buttons) b.setTexture(textures["button"]);
		});

		this.buttons[0].scale		= new Point(1.2, 1.0);
		this.buttons[1].scale		= new Point(1.0, 1.2);
		this.buttons[2].rotation	= PI / 10;
		this.buttons[3].scale		= new Point(0.8, 0.8);
		this.buttons[4].scale		= new Point(0.8, 1.2);
		this.buttons[4].rotation	= PI;

		window.requestAnimationFrame(this._animate);
	}


	void _animate(var num)
	{
		window.requestAnimationFrame(this._animate);
		this.renderer.render(this.stage);
	}
}


void main()
{
	new IteractivityExample();
}

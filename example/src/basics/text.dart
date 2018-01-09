part of pixi.examples;


class TextExample extends Example
{
	Application app;


	void run(CanvasElement canvas)
	{
		this.app = new Application(new Options(
			width: 800,
			height: 600,
			backgroundColor: 0x1099bb,
			view: canvas
		));

		var basicText = new Text('Basic text in pixi')
			..x = 30
			..y = 90;

		var style = new TextStyle(
			fontFamily: 'Arial',
			fontSize: '36px',
			fontStyle: 'italic',
			fontWeight: 'bold',
			fill: ['#ffffff', '#00ff99'],
			stroke: '#4a1850',
			strokeThickness: 5,
			dropShadow: true,
			dropShadowColor: '#000000',
			dropShadowBlur: 4,
			dropShadowAngle: PI / 6,
			dropShadowDistance: 6,
			wordWrap: true,
			wordWrapWidth: 440
		);

		var richText = new Text('Rich text with a lot of options and across multiple lines', style)
			..x = 30
			..y = 180;


		app.stage.addChild(basicText);
		app.stage.addChild(richText);
	}
}

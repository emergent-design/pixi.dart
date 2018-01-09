// part of pixi.examples;

// /*
//  * THIS EXAMPLE WILL NOT WORK WITHOUT THE pixi-picture plugin WHICH IS NOT INCLUDED
//  */
// class OverlayBlendModeDemo extends Example
// {
// 	Application app;
// 	List<Sprite> dudes;
// 	Rectangle dudeBounds;

// 	void run(CanvasElement canvas)
// 	{
// 		this.app	= new Application(new Options(view: canvas));

// 		var background = Sprite.fromImage('assets/demos/BGrotate.jpg')
// 			..width = app.screen.width
// 			..height = app.screen.height;


// 		this.dudes = new List.generate(20, (i) =>
// 			Sprite.fromImage('assets/demos/flowerTop.png')
// 				..anchor.set(0.5)
// 				..scale.set(0.8 + random.nextDouble() * 0.3)
// 				..pluginName = 'picture'
// 				..x = (random.nextDouble() * app.screen.width).floor()
// 				..y = (random.nextDouble() * app.screen.height).floor()
// 				..blendMode = random.nextDouble() > 0.5 ? BLEND_MODES.OVERLAY : BLEND_MODES.HARD_LIGHT
// 				..userdata = new Dude(
// 					direction: random.nextDouble() * PI * 2,
// 					turningSpeed: random.nextDouble() - 0.8,
// 					speed: 2 + random.nextDouble() * 2
// 				)
// 		);

// 		this.dudeBounds = new Rectangle(
// 			-100, -100,
// 			app.screen.width + 100 * 2,
// 			app.screen.height + 100 * 2
// 		);

// 		app.stage.addChild(background);
// 		app.stage.filters		= [ new AlphaFilter() ];
// 		app.stage.filterArea	= app.screen;

// 		this.dudes.forEach((d) => app.stage.addChild(d));
// 		app.ticker.add(allowInterop((_){
// 			for (var dude in this.dudes)
// 			{
// 				Dude.move(dude, this.dudeBounds);
// 			}
// 		}));
// 	}
// }
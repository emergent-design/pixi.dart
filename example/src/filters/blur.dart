part of pixi.examples;


class BlurFilterDemo extends Example
{
	Application app;


	void run(CanvasElement canvas)
	{
		this.app	= new Application(new Options(view: canvas));
		var count	= 0.0;

		List<BlurFilter> filters = [
			new BlurFilter(),
			new BlurFilter()
		];

		app.stage.addChild(
			Sprite.fromImage('assets/filters/depth_blur_BG.jpg')
				..width = app.screen.width
				..height = app.screen.height,

			Sprite.fromImage('assets/filters/depth_blur_dudes.jpg')
				..x = (app.screen.width / 2) - 315
				..y = 200
				..filters = [ filters[0] ],

			Sprite.fromImage('assets/filters/depth_blur_moby.jpg')
				..x = (app.screen.width / 2) - 200
				..y = 100
				..filters = [ filters[1] ]
		);

		app.ticker.add(allowInterop((_) {
			count += 0.005;
			filters[0].blur = 20 * cos(count);
			filters[1].blur = 20 * sin(count);
		}));
	}
}
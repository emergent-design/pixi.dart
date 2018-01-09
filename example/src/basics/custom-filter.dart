part of pixi.examples;


class CustomFilterExample extends Example
{
	Application app;
	Dynamic uniforms;
	Sprite bg;


	void run(CanvasElement canvas)
	{
		this.app	= new Application(new Options(view: canvas));
		this.bg 	= Sprite.fromImage('assets/basics/bkg-grass.jpg')
			..width = app.screen.width
			..height = app.screen.height;

		app
			..stop()
			..stage.addChild(this.bg)
			..ticker.add(allowInterop(
				(d) => this.uniforms['customUniform'] += 0.04)
			);

		new Loader()
			.add('shader', 'assets/basics/shader.frag')
			.once('complete', allowInterop(onLoaded))
			.load();
	}


	void onLoaded(Loader loader, DynamicSource resources)
	{
		var fragmentSrc = new Dynamic<Resource>(resources)['shader'].data;
		var filter		= new Filter(null, fragmentSrc);
		this.uniforms	= new Dynamic(filter.uniforms);
		this.bg.filters	= [ filter ];

		app.start();
	}
}

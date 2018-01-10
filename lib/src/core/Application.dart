part of pixi.core;

@JS()
class Application
{
	external Application([ Options options ]);

	external SystemRenderer get renderer;
	external Container get stage;
	external CanvasElement get view;
	external Rectangle get screen;

	external Ticker get ticker;
	external set ticker(Ticker ticker);

	external void render();
	external void stop();
	external void start();
	external void destroy([bool removeView = false]);
}


@JS()
class Ticker
{
	external Ticker add(void fn(num delta), [ dynamic context, num priority ]);
	external Ticker addOnce(void fn(num delta), [ dynamic context, num priority ]);
	external Ticker remove(void fn(num delta), [ dynamic context ]);

	external void start();
	external void stop();
	external void destroy();
	external void update([ num currentTime ]);

	external num get FPS;
	external num get minFPS;
	external set minFPS(num fps);
}


@JS() @anonymous
class Options
{
	external factory Options({
		bool autoStart,
		num width,
		num height,
		CanvasElement view,
		bool transparent,
		// bool autoResize,
		bool antialias,
		bool preserveDrawingBuffer,
		num resolution,
		bool forceCanvas,
		num backgroundColor,
		bool clearBeforeRender,
		bool roundPixels,
		bool forceFXAA,
		bool legacy,
		String powerPreference,
		bool sharedTicker,
		bool sharedLoader
	});
}
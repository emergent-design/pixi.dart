part of pixi.core;


@JS()
class BaseTexture
{
	external bool get hasLoaded;
	external num get height;
	external String get imageType;
	external bool get isLoading;
	external Object get origSource;
	external num get realHeight;
	external num get realWidth;
	external Object get source;
	external num get sourceScale;
	external num get width;

	external String get imageUrl;
	external set imageUrl(String value);

	external bool get mipmap;
	external set mipmap(bool value);

	external bool get premultipliedAlpha;
	external set premultipliedAlpha(bool value);

	external num get resolution;
	external set resolution(num value);

	external int get scaleMode;
	external set scaleMode(int value);

	external List<String> get textureCacheIds;
	external set textureCacheIds(List<String> values);

	external num get wrapMode;
	external set wrapMode(num value);


	external BaseTexture([Object source, int scaleMode, num resolution]);

	external static void addToCache(BaseTexture texture, String id);
	external static BaseTexture fromCanvas(CanvasElement canvas, int scaleMode);
	external static BaseTexture fromImage(String imageUrl, bool crossorigin, int scaleMode, num sourceScale);
	external static BaseTexture removeFromCache(String id);

	external void destroy();
	external void dispose();

	external void update();
	external void updateSourceImage(String newSrc);
}


@JS()
class Texture
{
	external Texture([BaseTexture baseTexture, Rectangle frame, Rectangle orig, Rectangle trim, num rotate]);

	external static Texture get EMPTY;
	external static Texture get WHITE;

	external BaseTexture get baseTexture;
	external set baseTexture(BaseTexture value);

	external Rectangle get frame;
	external set frame(Rectangle value);

	external num get height;
	external bool get noFrame;

	external Rectangle get orig;
	external set orig(Rectangle value);

	external bool get requiresUpdate;

	external num get rotate;
	external set rotate(num value);

	external List<String> get textureCacheIds;
	external set textureCacheIds(List<String> values);

	external Rectangle get trim;
	external set trim(Rectangle value);

	external bool get valid;
	external num get width;


	external static void addToCache(Texture texture, String id);
	external static Texture removeFromCache(String id);

	external static Texture fromCanvas(CanvasElement canvas, [ int scaleMode ]);
	external static Texture fromFrame(String frameId);
	external static Texture fromImage(String imageUrl, [ bool crossorigin, int scaleMode ]);
	external static Texture fromVideo(VideoElement video, [ int scaleMode ]);
	external static Texture fromVideoUrl(String videoUrl, [ int scaleMode ]);

	external Texture clone();
	external void destroy([ bool destroyBase ]);
	external void update();
}


@JS()
class BaseRenderTexture extends BaseTexture
{
	external BaseRenderTexture([num width, num height, int scaleMode, num resolution ]);

	external void resize(num width, num height);
}


@JS()
class RenderTexture extends Texture
{
	external RenderTexture(BaseRenderTexture baseRenderTexture, [Rectangle frame]);

	external static RenderTexture create([num width, num height, int scaleMode, num resolution]);

	external void resize(num width, num height, bool doNotResizeBaseTexture);
}

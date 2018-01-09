part of pixi.core;


@JS()
external SystemRenderer autoDetectRenderer(num width, num height, [ Options options, bool noWebGL ]);


@JS()
abstract class SystemRenderer
{
	external void destroy([bool removeView = false ]);

	external Texture generateTexture(DisplayObject object, num scaleMode, num resolution, [ Rectangle region ]);
	external void render(DisplayObject object, [RenderTexture renderTexture, bool clear, Transform transform, bool skipUpdateTransform]);
	external void resize(num screenWidth, num screenHeight);

	external CanvasElement get view;
	external set view(CanvasElement);

	external num get type;
	external num get width;
	external num get height;
}


@JS()
class CanvasRenderer extends SystemRenderer
{
	external CanvasRenderer([ Options options ]);
}


@JS()
class WebGLRenderer extends SystemRenderer
{
	external WebGLRenderer([ Options options ]);
}


@JS()
class Filter
{
	external num get padding;
	external set padding(num value);

	external DynamicSource get uniforms;
	external set uniforms(DynamicSource value);

	external Filter([String vertexSrc, String fragmentSrc, DynamicSource uniforms]);
}


@JS()
class Shader
{
	external Shader(dynamic context, String vertexSrc, String fragmentSrc);
}
@JS('PIXI.filters')
library pixi.filters;

import 'package:js/js.dart';
import 'Core.dart';


@JS()
class AlphaFilter extends Filter
{
	external AlphaFilter([num alpha]);
	external num get alpha;
	external set alpha(num value);
}

@JS()
class BlurFilter extends Filter
{
	external BlurFilter([ num strength, num quality, num resolution, num kernelSize ]);
	external num get blur;
	external set blur(num value);
	external num get quality;
	external set quality(num value);
	external num get blurX;
	external set blurX(num value);
	external num get blurY;
	external set blurY(num value);
	external num get blendMode;
	external set blendMode(num value);
}

@JS()
class BlurXFilter extends Filter
{
	external BlurXFilter([ num strength, num quality, num resolution, num kernelSize ]);
	external num get blur;
	external set blur(num value);
	external num get quality;
	external set quality(num value);
}

@JS()
class BlurYFilter extends Filter
{
	external BlurYFilter([ num strength, num quality, num resolution, num kernelSize ]);
	external num get blur;
	external set blur(num value);
	external num get quality;
	external set quality(num value);
}

@JS()
class ColorMatrixFilter extends Filter
{
	external void brightness(num b, bool multiply);
	external void greyscale(num scale, bool multiply);
	external void blackAndWhite(bool multiply);
	external void hue(num rotation, bool multiply);
	external void contrast(num amount, bool multiply);
	external void saturate(num amount, bool multiply);
	external void desaturate();
	external void negative(bool multiply);
	external void sepia(bool multiply);
	external void technicolor(bool multiply);
	external void polaroid(bool multiply);
	external void toBGR(bool multiply);
	external void kodachrome(bool multiply);
	external void browni(bool multiply);
	external void vintage(bool multiply);
	external void colorTone(num desaturation, num toned, String lightColor, String darkColor, bool multiply);
	external void night(num intensity, bool multiply);
	external void predator(num amout, bool multiply);
	external void lsd(bool multiply);
	external void reset();

	external List<num> get matrix;
	external set matrix(List<num> value);
	external num get alpha;
	external set alpha(num value);
}

@JS()
class DisplacementFilter extends Filter
{
	external DisplacementFilter(Sprite sprite, [ num scale ]);

	external Texture get map;
	external set map(Texture value);

	external Point get scale;
	external set scale(Point value);
}

@JS()
class FXAAFilter extends Filter
{}

@JS()
class NoiseFilter extends Filter
{
	external NoiseFilter([ num noise, num seed ]);
	external num get noise;
	external set noise(num value);
	external num get seed;
	external set seed(num value);
}
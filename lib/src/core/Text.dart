part of pixi.core;


@JS()
class Text extends Sprite
{
	external num get resolution;
	external set resolution(num value);

	external TextStyle get style;
	external set style(TextStyle value);

	external String get text;
	external set text(String value);

	external Text(String text, [ TextStyle style, CanvasElement canvas ]);
}


@JS() @anonymous
class TextStyle
{
	external String get align;
	external bool get breakWords;
	external bool get dropShadow;
	external num get dropShadowAlpha;
	external num get dropShadowAngle;
	external num get dropShadowBlur;
	external String get dropShadowColor;
	external num get dropShadowDistance;
	external dynamic get fill;
	external num get fillGradientType;
	external List<num> get fillGradientStops;

	external String get fontFamily;
	external dynamic get fontSize;
	external String get fontStyle;
	external String get fontVariant;
	external String get fontWeight;

	external num get leading;
	external num get letterSpacing;
	external num get lineHeight;
	external String get lineJoin;
	external num get miterLimit;
	external num get padding;
	external String get stroke;
	external num get strokeThickness;
	external bool get trim;
	external String get textBaseline;
	external bool get wordWrap;
	external num get wordWrapWidth;

	external factory TextStyle({
		String align,
		bool breakWords,
		bool dropShadow,
		num dropShadowAlpha,
		num dropShadowAngle,
		num dropShadowBlur,
		String dropShadowColor,
		num dropShadowDistance,
		dynamic fill,			// String, List<String>
		num fillGradientType,
		List<num> fillGradientStops,
		String fontFamily,		// Number is pixels, string is CSS sizing
		dynamic fontSize,
		String fontStyle,
		String fontVariant,
		String fontWeight,
		num leading,
		num letterSpacing,
		num lineHeight,
		String lineJoin,
		num miterLimit,
		num padding,
		String stroke,
		num strokeThickness,
		bool trim,
		String textBaseline,
		bool wordWrap,
		num wordWrapWidth
	});
}

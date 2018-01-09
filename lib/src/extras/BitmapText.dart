part of pixi.extras;


@JS()
class BitmapText extends Container
{
	external BitmapText(String text, [BitmapTextStyle style]);

	external String get align;
	external set align(String value);

	external String get font;
	external set font(String value);

	external num get maxLineHeight;
	external set maxLineHeight(num value);

	external num get maxWidth;
	external set maxWidth(num value);

	external String get text;
	external set text(String value);

	external num get textHeight;
	external num get textWidth;

	external num get tint;
	external set tint(num value);
}


@JS()
@anonymous
class BitmapTextStyle
{
	external factory BitmapTextStyle({
		String font,
		String align,
		num tint
	});
}


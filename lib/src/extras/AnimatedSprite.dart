part of pixi.extras;


@JS()
class AnimatedSprite extends Sprite
{
	external AnimatedSprite(List<Texture> textures);

	external num get animationSpeed;
	external set animationSpeed(num value);

	external num get currentFrame;

	external bool get loop;
	external set loop(bool value);

	external bool get playing;

	external List<Texture> get textures;
	external set textures(List<Texture> value);

	external num get totalFrames;


	external static AnimatedSprite fromFrames(List<String> frames);
	external static AnimatedSprite fromImages(List<String> images);

	external void gotoAndPlay(num frameNumber);
	external void gotoAndStop(num frameNumber);
	external void play();
	external void stop();
}

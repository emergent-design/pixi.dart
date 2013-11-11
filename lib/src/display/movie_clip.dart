part of pixi;


class MovieClip extends Sprite
{
	List<Texture> _textures;
	double animationSpeed	= 1.0;
	bool loop				= true;
	double _currentFrame	= 0.0;
	bool _playing			= false;

	double get currentFrame => this._currentFrame;
	bool get playing		=> this._playing;
	int get totalFrames		=> this._textures.length;

	StreamController _completeController = new StreamController.broadcast();
	Stream get onComplete => this._completeController.stream;


	MovieClip(List<Texture> textures) : super(textures[0])
	{
		this._textures = textures;
	}


	void play()
	{
		this._playing = true;
	}


	void stop()
	{
		this._playing = false;
	}


	void gotoAndStop(num frameNumber)
	{
		this._playing		= false;
		this._currentFrame	= frameNumber.toDouble();
		int index			= this._currentFrame.round();

		if (index < this._textures.length)
		{
			this.setTexture(this._textures[index]);
		}
	}


	void gotoAndPlay(num frameNumber)
	{
		this._currentFrame	= frameNumber.toDouble();
		this._playing		= true;
	}


	void _updateTransform(DisplayObject parent)
	{
		super._updateTransform(parent);

		if (!this._playing) return;

		this._currentFrame += this.animationSpeed;
		int index	= this._currentFrame.round();
		int length	= this._textures.length;

		if (this.loop || index < length)
		{
			this.setTexture(this._textures[index % length]);
		}
		else if (index >= length)
		{
			this.gotoAndStop(length - 1);
			this._completeController.add('complete');
		}
	}
}

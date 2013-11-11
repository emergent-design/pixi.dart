part of pixi;


class Stage extends DisplayObjectContainer
{
	Colour backgroundColor;
	bool interactive;


	Stage([this.backgroundColor = const Colour(255, 255, 255), this.interactive = false])
	{
		this._worldTransform	= new Mat3();
		this._worldAlpha		= 1.0;
	}
}

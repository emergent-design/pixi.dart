part of pixi;


class ImageLoader extends BaseLoader
{
	Texture _texture;


	ImageLoader(String url, bool crossorigin)
	{
		this._texture = new Texture.fromImage(url, crossorigin);
	}


	void load()
	{
		if (!this._texture.hasLoaded)
		{
			this._texture.onLoaded.listen(
				(i) => this._loadedController.add('loaded'),
				onError: (e) => this._errorController.add(e)
			);
		}
		else this._loadedController.add('loaded');
	}
}


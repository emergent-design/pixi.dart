part of pixi;


class JsonLoader extends BaseLoader
{
	String _url;
	String _baseUrl;
	bool _crossorigin;

	JsonLoader(String url, bool crossorigin)
	{
		this._url			= url;
		this._crossorigin	= crossorigin;
		this._baseUrl		= url.replaceAll(new RegExp(r'[^\/]*$'), '');
	}


	void load()
	{
		HttpRequest.request(this._url, mimeType: 'application/json').then(
			(response) => this._handle(JSON.decode(response.responseText)),
			onError: (e) => this._errorController.add(e)
		);
	}


	void _handle(Map<String, dynamic> json)
	{
		if (json['frames'] != null)
		{
			var url		= this._baseUrl + json['meta']['image'];
			var image	= new ImageLoader(url, this._crossorigin);
			var texture	= image._texture._base;

			image.onLoaded.listen(
				(i) => this._loadedController.add('loaded'),
				onError: (e) => this._errorController.add(e)
			);

			json['frames'].forEach((k, v) {
				var rect = v['frame'];

				if (rect != null)
				{
					Texture.addTextureToCache(
						new Texture(texture, new Rectangle(rect['x'], rect['y'], rect['w'], rect['h'])), k
					);

					if (v['trimmed'])
					{
						// TODO
					}
				}
			});

			image.load();
		}
		else if (json['bones'] != null)
		{
			// TODO
			this._loadedController.add('loaded');
		}
		else this._loadedController.add('loaded');
	}
}

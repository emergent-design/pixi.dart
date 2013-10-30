part of pixi;



abstract class BaseLoader
{
	StreamController _loadedController = new StreamController.broadcast();
	Stream get onLoaded => this._loadedController.stream;

	StreamController _errorController = new StreamController.broadcast();
	Stream get onError => this._errorController.stream;

	void load();
}


class AssetLoader
{
	static Map<String, Function> loaders = {
		'jpg':	(url, c) => new ImageLoader(url, c),
		'jpeg':	(url, c) => new ImageLoader(url, c),
		'png':	(url, c) => new ImageLoader(url, c),
		'gif':	(url, c) => new ImageLoader(url, c),
		'json':	(url, c) => new JsonLoader(url, c),
		//'amin':	(url, c) => new SpineLoader(url, c),
		'fnt':	(url, c) => new BitmapFontLoader(url, c),
		'xml':	(url, c) => new BitmapFontLoader(url, c),
	};

	List<String> _assetUrls;
	bool _crossorigin;

	StreamController _progressController = new StreamController.broadcast();
	Stream<double> get onProgress => this._progressController.stream;

	StreamController _completeController = new StreamController.broadcast();
	Stream get onComplete => this._completeController.stream;


	AssetLoader(this._assetUrls, [ this._crossorigin = false ]);

	void load()
	{
		int total = this._assetUrls.length;
		int count = 0;

		for (var asset in this._assetUrls)
		{
			var ext 	= asset.split('.').last.toLowerCase();
			var type	= loaders[ext];

			if (type == null) throw "$ext is an unsupported file type";

			BaseLoader loader = type(asset, this._crossorigin);

			loader.onLoaded.listen((i) {
				count++;

				this._progressController.add(count.toDouble() / total.toDouble());

				if (count == total)
				{
					this._completeController.add('complete');
				}
			});

			loader.load();
		}
	}
}

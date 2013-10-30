part of pixi;





class BitmapFontLoader extends BaseLoader
{

	String _url;
	String _baseUrl;
	bool _crossorigin;
	//BaseTexture _texture;


	BitmapFontLoader(String url, bool crossorigin)
	{
		this._url			= url;
		this._crossorigin	= crossorigin;
		this._baseUrl		= url.replaceAll(new RegExp(r'[^\/]*$'), '');
	}


	void load()
	{
		HttpRequest.request(this._url, mimeType: 'application/xml').then(
			(response) => this._handle(response.responseXml),
			onError: (e) => this._errorController.add(e)
		);
	}


	void _handle(Document xml)
	{
		var url 	= this._baseUrl + xml.querySelectorAll("page").first.getAttribute("file");
		var image 	= new ImageLoader(url, this._crossorigin);
		var texture	= image._texture._base;

		image.onLoaded.listen(
			(i) => this._loadedController.add('loaded'),
			onError: (e) => this._errorController.add(e)
		);

		var info = xml.querySelector("info");
		var data = new _Font()
			..font 			= info.getAttribute("face")
			..size 			= int.parse(info.getAttribute("size"), radix: 10)
			..lineHeight	= int.parse(xml.querySelector("common").getAttribute("lineHeight"), radix: 10);

		for (var letter in xml.querySelectorAll("char"))
		{
			var code = int.parse(letter.getAttribute("id"), radix: 10);

			data.chars[code] = new _CharData()
				..xOffset	= int.parse(letter.getAttribute("xoffset"), radix: 10)
				..yOffset	= int.parse(letter.getAttribute("yoffset"), radix: 10)
				..xAdvance	= int.parse(letter.getAttribute("xadvance"), radix: 10)
				..texture	= new Texture(texture, new Rectangle(
					int.parse(letter.getAttribute("x"), radix: 10),
					int.parse(letter.getAttribute("y"), radix: 10),
					int.parse(letter.getAttribute("width"), radix: 10),
					int.parse(letter.getAttribute("height"), radix: 10)
				));
		}

		for (var k in xml.querySelectorAll("kerning"))
		{
			var a = int.parse(k.getAttribute("second"), radix: 10);
			var b = int.parse(k.getAttribute("first"), radix: 10);
			data.chars[a].kerning[b] = int.parse(k.getAttribute("amount"), radix: 10);
		}

		BitmapText._fonts[data.font] = data;
		image.load();
	}
}

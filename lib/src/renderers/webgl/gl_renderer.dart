part of pixi;


class WebGLRenderer extends Renderer
{
	GL.RenderingContext _context	= null;
	bool _contextLost				= false;
	Point _projection				= new Point(400, -300);
	Point _offset					= new Point(0, 0);

	_BaseShader _shader				= null;
	_SpriteShader _spriteShader		= null;
	_GraphicsShader _graphicsShader	= null;
	_StripShader _stripShader		= null;

	_BaseBatch _batch				= null;
	_GLGraphics _graphics			= null;
	_GLTilingSprite _tiling			= null;



	WebGLRenderer({int width: 800, int height: 600, CanvasElement view: null, bool transparent: false, bool antialias: false }) : super(width, height, view, transparent)
	{
		this._context = this._view.getContext3d(alpha: transparent, stencil: true, antialias: antialias, premultipliedAlpha: false);

		if (this._context == null) throw "This browser does not support webGL. Try using the canvas renderer";

		this._view.onWebGlContextLost.listen(this._handleContextLost);
		this._view.onWebGlContextRestored.listen(this._handleContextRestored);

		var gl					= this._context;
		this._spriteShader		= new _SpriteShader(gl);
		this._graphicsShader	= new _GraphicsShader(gl);
		this._stripShader		= new _StripShader(gl);

		gl.disable(GL.DEPTH_TEST);
		gl.disable(GL.CULL_FACE);
		gl.enable(GL.BLEND);

		// Disabling the alpha in the colour mask seems to prevent it from rendering properly
		// if the background colour of the page is white despite the alpha and premultipliedAlpha
		// options above being disabled.
		gl.colorMask(true, true, true, true);

		this.resize(width, height);

		this._batch		= new _SimpleBatch(gl, this._spriteShader, 1000);
		this._graphics	= new _GLGraphics(gl, this._graphicsShader);
		this._tiling	= new _GLTilingSprite(gl, this._stripShader);
	}


	void resize(int width, int height)
	{
		super.resize(width, height);

		this._projection = new Point(width / 2, -height / 2);
		this._context.viewport(0, 0, width, height);
	}


	void render(Stage stage)
	{
		if (this._contextLost) return;

		this._updateTextures();

		var gl = this._context;

		gl.bindFramebuffer(GL.FRAMEBUFFER, null);

		if (!this._transparent)
		{
			gl.clearColor(stage.backgroundColor.r / 255.0, stage.backgroundColor.g / 255.0, stage.backgroundColor.b / 255.0, 1.0);
		}
		else gl.clearColor(0, 0, 0, 0);

		gl.clear(GL.COLOR_BUFFER_BIT);

		this._batch.begin(this._projection);
		stage._render(this);
		this._batch.end();

		//print(this._batch.totalRenderCalls);

		if (stage.interactive)
		{
			// ??
		}
	}


	void _setShader(_BaseShader shader)
	{
		if (this._shader != shader)
		{
			if (this._shader != null) this._shader.deactivate(this._context);

			shader.activate(this._context);

			this._shader = shader;
		}
	}


	void _renderGraphics(Graphics graphics)
	{
		this._batch.flush();
		this._setShader(this._graphicsShader);
		this._graphics.renderGraphics(graphics, this._projection, this._offset);
	}


	void _renderSprite(Sprite sprite)
	{
		this._setShader(this._spriteShader);
		this._batch.renderSprite(sprite);
	}


	void _renderTilingSprite(TilingSprite sprite)
	{
		this._setShader(this._stripShader);
		this._tiling.renderSprite(sprite, this._projection, this._offset);
	}


	void _updateTextures()
	{
		for (var t in BaseTexture._toUpdate)	_updateTexture(t);
		for (var t in BaseTexture._toDestroy)	_destroyTexture(t);

		BaseTexture._toUpdate.clear();
		BaseTexture._toDestroy.clear();
	}


	void _updateTexture(BaseTexture texture)
	{
		var gl = this._context;

		if (texture._glTexture == null)
		{
			texture._glTexture = gl.createTexture();
		}

		if (texture.hasLoaded)
		{
			gl.bindTexture(GL.TEXTURE_2D, texture._glTexture);
		 	gl.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, GL.ONE);

			gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, texture._source);
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
			gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);

			if (!texture._powerOf2)
			{
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
			}
			else
			{
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
			}

			gl.bindTexture(GL.TEXTURE_2D, null);
		}
	}


	void _destroyTexture(BaseTexture texture)
	{
		var gl = this._context;

		if (texture._glTexture != null)
		{
			gl.deleteTexture(texture._glTexture);
		}
	}


	void _handleContextLost(GL.ContextEvent e)
	{
		print("Context lost");
		e.preventDefault();
		this._contextLost = false;
	}


	void _handleContextRestored(GL.ContextEvent e)
	{
		print("Context restored");

		// Update rendergroup??

		/*
		 * this.gl = this.view.getContext("experimental-webgl",  {
		alpha: true
    });

	this.initShaders();

	for(var key in PIXI.TextureCache)
	{
        	var texture = PIXI.TextureCache[key].baseTexture;
        	texture._glTexture = null;
        	PIXI.WebGLRenderer.updateTexture(texture);
	};

	for (var i=0; i <  this.batchs.length; i++)
	{
		this.batchs[i].restoreLostContext(this.gl)//
		this.batchs[i].dirty = true;
	};

	PIXI._restoreBatchs(this.gl);

	this.contextLost = false;
		 */
	}


}

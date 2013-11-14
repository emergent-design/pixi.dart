part of pixi;

// The base batcher for rendering sprite quads (indexed triangles).
// Based on the implementation at https://github.com/mattdesl/pixi.js
// by Matt DesLauriers

abstract class _BaseBatch
{
	static const MAX_SIZE = 8000;

	Map<BaseTexture, GL.Texture> glTextures = {};

	GL.RenderingContext gl;
	GL.Buffer vertexBuffer;
	GL.Buffer indexBuffer;

	Float32List vertices;
	Uint16List indices;
	int size;

	bool drawing			= false;
	int index				= 0;
	int totalRenderCalls	= 0;
	Point projection;
	// Blend mode, flush if changed??

	// Abstract properties and functions
	int get vertexSize;
	_BaseShader get shader;

	void bind();
	void render(Sprite sprite, List<num> uvs);


	_BaseBatch(GL.RenderingContext gl, this.size)
	{
		if (this.size > MAX_SIZE) throw "The largest batch size permitted is ${MAX_SIZE}";

		var numv 		= this.size * 4 * this.vertexSize;
		var numi 		= this.size * 6;
		this.vertices	= new Float32List(numv);
		this.indices	= new Uint16List(numi);

		for (int i=0, j=0; i<numi; i+=6, j+=4)
		{
			this.indices[i + 0] = j + 0;
			this.indices[i + 1] = j + 1;
			this.indices[i + 2] = j + 2;
			this.indices[i + 3] = j + 0;
			this.indices[i + 4] = j + 2;
			this.indices[i + 5] = j + 3;
		}

		this.initialise(gl);
	}


	GL.Texture glTexture(BaseTexture texture)
	{
		if (!texture.hasLoaded) throw "Attempting to generate a GL texture when the base texture has not loaded yet";

		var result = this.glTextures.putIfAbsent(texture, () => gl.createTexture());

		if (texture._dirtyTexture)
		{
			if (texture._source != null)
			{
				gl.bindTexture(GL.TEXTURE_2D, result);
				gl.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, GL.ONE);

				gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, GL.RGBA, GL.UNSIGNED_BYTE, texture._source);
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
				gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);

				if (_isPowerOfTwo(texture.width) && _isPowerOfTwo(texture.height))
				{
					gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
					gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
				}
				else
				{
					gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
					gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
				}

				gl.bindTexture(GL.TEXTURE_2D, null);
			}
			else throw "Attempting to use a texture without a source";

			texture._dirtyTexture = false;
		}

		return result;
	}


	static bool _isPowerOfTwo(int value)
	{
		return (value & (value - 1)) == 0;
	}


	void destroyTexture(BaseTexture texture)
	{
		if (this.glTextures.containsKey(texture))
		{
			this.gl.deleteTexture(this.glTextures[texture]);
			this.glTextures.remove(texture);
		}
	}


	void destroy()
	{
		if (this.vertexBuffer != null)	this.gl.deleteBuffer(this.vertexBuffer);
		if (this.indexBuffer != null)	this.gl.deleteBuffer(this.indexBuffer);
		this.vertices	= null;
		this.indices	= null;
		this.size		= 0;

		for (var t in this.glTextures.values) this.gl.deleteTexture(t);
		this.glTextures.clear();
	}


	void initialise(GL.RenderingContext gl)
	{
		this.gl				= gl;
		this.vertexBuffer 	= gl.createBuffer();
		this.indexBuffer	= gl.createBuffer();

		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
    	gl.bufferDataTyped(GL.ELEMENT_ARRAY_BUFFER, this.indices, GL.STATIC_DRAW);

		gl.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);
		gl.bufferDataTyped(GL.ARRAY_BUFFER, this.vertices, GL.DYNAMIC_DRAW);
	}


	// Begins the sprite batch. Subclasses should then bind shaders,
	// upload projection matrix, and bind textures.
	void begin(Point projection)
	{
		if (this.drawing) throw "Cannot call begin during drawing";

		this.drawing			= true;
		this.projection			= projection;
		this.totalRenderCalls	= 0;

		gl.depthMask(false);
		gl.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
	}


	void end()
	{
		if (!this.drawing)	throw "Cannot end a batch that was not begun";
		if (this.index > 0)	this.flush();

		this.drawing = false;
		this.gl.depthMask(true);
	}


	void flush()
	{
		if (this.index == 0) return;
		this.totalRenderCalls++;

		gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, this.indexBuffer);
		gl.bindBuffer(GL.ARRAY_BUFFER, this.vertexBuffer);

		// Only update the buffer with vertices that are actually being used by using a light-weight view.
		gl.bufferSubDataTyped(GL.ARRAY_BUFFER, 0, new Float32List.view(this.vertices.buffer, 0, this.index));

		this.bind();

		int count = this.index ~/ (this.vertexSize * 4);

		gl.drawElements(GL.TRIANGLES, count * 6, GL.UNSIGNED_SHORT, 0);

		this.index = 0;
	}


	void renderSprite(Sprite sprite)
	{
		var texture	= sprite._texture;
		var frame	= texture.frame;

		//if (frame == null || texture == null || texture._base == null || texture._base._glTexture == null) return;
		if (frame == null || texture == null || texture._base == null || !texture._base.hasLoaded) return;

		this.render(sprite, [
			frame.left / texture._base.width, frame.top / texture._base.height,
			(frame.left + frame.width) / texture._base.width, (frame.top + frame.height) / texture._base.height,
		]);
	}


	void renderTilingSprite(TilingSprite sprite)
	{
		var texture	= sprite._texture;
		var frame	= texture.frame;

		//if (frame == null || texture == null || texture._base == null || texture._base._glTexture == null) return;
		if (frame == null || texture == null || texture._base == null || !texture._base.hasLoaded) return;

		var position	= sprite.tilePosition;
		var scale		= sprite.tileScale;
		double offsetX	= position.x / texture._base.width;
		double offsetY	= position.y / texture._base.height;
		double scaleX	= (sprite._width / texture._base.width) / scale.x;
		double scaleY	= (sprite._height / texture._base.height) / scale.y;

		this.render(sprite, [
			-offsetX, -offsetY,
			scaleX - offsetX, scaleY - offsetY
		]);
	}
}
